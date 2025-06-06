"""Determines whether we can compute a valid join for the given inputs.

For example:

I have a node containing a measure that's needed for a metric, and I also have a list of dimensions that I need for that
measure.

Can I join that node with other nodes using a common entity to get those dimensions? If so, what are those nodes,
what entity should I join on, and if I do that join, what dimensions can be retrieved?

Note: the term "dimension" is used below, but it actually refers to any LinkableInstance. Also, when you see the term
"left_node", think "node containing the measure". Using the term "left_node" as the scenario of joining measure nodes
to dimension nodes is an easy case to explain, but there are non-measure nodes that can be joined with dimension nodes
to realize other planned features.
"""

from __future__ import annotations

import itertools
import logging
from dataclasses import dataclass
from typing import List, Optional, Sequence, Tuple

from dbt_semantic_interfaces.naming.keywords import METRIC_TIME_ELEMENT_NAME
from metricflow_semantics.instances import InstanceSet
from metricflow_semantics.mf_logging.lazy_formattable import LazyFormat
from metricflow_semantics.mf_logging.pretty_print import mf_pformat
from metricflow_semantics.model.semantics.semantic_model_join_evaluator import SemanticModelJoinEvaluator
from metricflow_semantics.model.semantics.semantic_model_lookup import SemanticModelLookup
from metricflow_semantics.specs.entity_spec import LinklessEntitySpec
from metricflow_semantics.specs.instance_spec import LinkableInstanceSpec
from metricflow_semantics.specs.spec_set import group_specs_by_type
from metricflow_semantics.sql.sql_join_type import SqlJoinType

from metricflow.dataflow.builder.partitions import (
    PartitionDimensionJoinDescription,
    PartitionJoinResolver,
    PartitionTimeDimensionJoinDescription,
)
from metricflow.dataflow.dataflow_plan import DataflowPlanNode
from metricflow.dataflow.nodes.filter_elements import FilterElementsNode
from metricflow.dataflow.nodes.join_to_base import JoinDescription, ValidityWindowJoinDescription
from metricflow.dataflow.nodes.metric_time_transform import MetricTimeDimensionTransformNode
from metricflow.dataset.dataset_classes import DataSet
from metricflow.dataset.sql_dataset import SqlDataSet
from metricflow.plan_conversion.instance_set_transforms.instance_converters import CreateValidityWindowJoinDescription
from metricflow.plan_conversion.to_sql_plan.dataflow_to_subquery import DataflowNodeToSqlSubqueryVisitor

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class JoinLinkableInstancesRecipe:
    """A recipe for how to join a node containing linkable instances to the "left_node".

    node_to_join contains the linkable instances that are needed - it should be filtered so that the output data set of
    that node only includes the entity instance for the join and the instances associated with
    satisfiable_linkable_specs.
    """

    node_to_join: DataflowPlanNode
    # The entity to join "node_to_join" on. Only nullable if using CROSS JOIN.
    join_on_entity: Optional[LinklessEntitySpec]
    # The linkable instances from the query that can be satisfied if we join this node. Note that this is different from
    # the linkable specs in the node that can help to satisfy the query. e.g. "user_id__country" might be one of the
    # "satisfiable_linkable_specs", but "country" is the linkable spec in the node.
    satisfiable_linkable_specs: List[LinkableInstanceSpec]
    # Join type to use when joining nodes
    join_type: SqlJoinType

    # The partitions to join on, if there are matching partitions between the left_node and node_to_join.
    join_on_partition_dimensions: Tuple[PartitionDimensionJoinDescription, ...]
    join_on_partition_time_dimensions: Tuple[PartitionTimeDimensionJoinDescription, ...]

    validity_window: Optional[ValidityWindowJoinDescription] = None

    def __post_init__(self) -> None:  # noqa: D105
        if self.join_on_entity is None and self.join_type != SqlJoinType.CROSS_JOIN:
            raise RuntimeError("`join_on_entity` is required unless using CROSS JOIN.")

    # TODO: JoinDescription is very similar to JoinLinkableInstancesRecipe. Can we consolidate by just adding a
    # `filtered_node_to_join` property on JoinLinkableInstancesRecipe?
    @property
    def join_description(self) -> JoinDescription:
        """The recipe as a join description to use in the dataflow plan node.

        Here, we figure out which instance specs to keep from this node in order to join to it and render its
        satisfiable linkable specs, e.g. if the node is used to satisfy "user_id__country", the node must have the
        entity "user_id" and the "country" dimension so that it can be joined to the source node.
        """
        include_specs: List[LinkableInstanceSpec] = []
        assert all(
            [
                len(spec.entity_links) > 0
                for spec in self.satisfiable_linkable_specs
                if not spec.element_name == METRIC_TIME_ELEMENT_NAME
            ]
        )

        # Get the specs needed to join onto this node.
        if self.node_to_join.aggregated_to_elements:
            include_specs.extend(self.node_to_join.aggregated_to_elements)
        else:
            for spec in self.satisfiable_linkable_specs:
                if len(spec.entity_links) > 0:
                    include_specs.append(LinklessEntitySpec.from_reference(spec.entity_links[0]))

        include_specs.extend([join.node_to_join_dimension_spec for join in self.join_on_partition_dimensions])
        include_specs.extend([join.node_to_join_time_dimension_spec for join in self.join_on_partition_time_dimensions])
        if self.validity_window:
            include_specs.extend(
                [self.validity_window.window_start_dimension, self.validity_window.window_end_dimension]
            )

        # `satisfiable_linkable_specs` describes what can be satisfied after the join, so remove the entity
        # link when filtering before the join.
        include_specs.extend(
            [
                spec.without_first_entity_link if len(spec.entity_links) > 0 else spec
                for spec in self.satisfiable_linkable_specs
            ]
        )

        filtered_node_to_join = FilterElementsNode.create(
            parent_node=self.node_to_join, include_specs=group_specs_by_type(include_specs).dedupe()
        )

        return JoinDescription(
            join_node=filtered_node_to_join,
            join_on_entity=self.join_on_entity,
            join_on_partition_dimensions=self.join_on_partition_dimensions,
            join_on_partition_time_dimensions=self.join_on_partition_time_dimensions,
            validity_window=self.validity_window,
            join_type=self.join_type,
        )


@dataclass(frozen=True)
class LinkableInstanceSatisfiabilityEvaluation:
    """Evaluation for a node on the ability to get linkable instances that we need to resolve a query.

    Includes whether the node contains the linkable instances that we need (local_linkable_specs), or if it can have
    them joined in (joinable_linkable_specs). Linkable instances that can't be satisfied either locally or via joins are
    listed in unjoinable_linkable_specs.
    """

    local_linkable_specs: Tuple[LinkableInstanceSpec, ...]
    joinable_linkable_specs: Tuple[LinkableInstanceSpec, ...]
    join_recipes: Tuple[JoinLinkableInstancesRecipe, ...]
    unjoinable_linkable_specs: Tuple[LinkableInstanceSpec, ...]


class NodeEvaluatorForLinkableInstances:
    """Helps to evaluate if linkable instances can be obtained using the given node, with joins if necessary.

    For example, consider a "left_node" (that will be on the left side of the join) containing the "bookings" measure,
    "is_instant" dimension, and "listing_id" entity with nodes_available_for_joins including a node with the
    "listing_id" entity, and the "country" dimension.

    We want to know if we can get "bookings", "is_instant", "listing_id__country" using the left_node. The result
    should be that we know: "is_instant" is available locally (i.e. in the same node), and if we join another node
    (on the right side of the join) containing "listing_id" and "country" by "listing_id", we can get
    "listing_id__country".

    """

    def __init__(
        self,
        semantic_model_lookup: SemanticModelLookup,
        nodes_available_for_joins: Sequence[DataflowPlanNode],
        node_data_set_resolver: DataflowNodeToSqlSubqueryVisitor,
        time_spine_metric_time_nodes: Sequence[MetricTimeDimensionTransformNode],
    ) -> None:
        """Initializer.

        Args:
            semantic_model_lookup: Needed to resolve partition dimensions.
            nodes_available_for_joins: Nodes that contain linkable instances and may be joined with "left_node" (on the
            left side of the join and containing a desired measure) to retrieve the needed linkable instances.
            node_data_set_resolver: Figures out what data set is output by a node.
            time_spine_node: If nodes_available_for_joins contains a time spine node, it should be identical to this
            one as there is logic to check for equality.
        """
        self._semantic_model_lookup = semantic_model_lookup
        self._nodes_available_for_joins = nodes_available_for_joins
        self._node_data_set_resolver = node_data_set_resolver
        self._partition_resolver = PartitionJoinResolver(self._semantic_model_lookup)
        self._join_evaluator = SemanticModelJoinEvaluator(self._semantic_model_lookup)
        self._time_spine_metric_time_nodes = time_spine_metric_time_nodes

    def _find_joinable_candidate_nodes_that_can_satisfy_linkable_specs(
        self,
        left_node_instance_set: InstanceSet,
        needed_linkable_specs: List[LinkableInstanceSpec],
        default_join_type: SqlJoinType,
    ) -> List[JoinLinkableInstancesRecipe]:
        """Get nodes that can be joined to get 1 or more of the "needed_linkable_specs".

        The returned list is ordered by the number of "needed_linkable_specs" that it can satisfy.
        """
        candidates_for_join: List[JoinLinkableInstancesRecipe] = []
        left_node_spec_set = left_node_instance_set.spec_set
        for right_node in self._nodes_available_for_joins:
            data_set_in_right_node: SqlDataSet = self._node_data_set_resolver.get_output_data_set(right_node)
            linkable_specs_in_right_node = data_set_in_right_node.instance_set.spec_set.linkable_specs

            # If right node is time spine source node, use cross join.
            if right_node in self._time_spine_metric_time_nodes:
                satisfiable_metric_time_specs = [
                    spec for spec in linkable_specs_in_right_node if spec in needed_linkable_specs
                ]
                candidates_for_join.append(
                    JoinLinkableInstancesRecipe(
                        node_to_join=right_node,
                        join_on_entity=None,
                        satisfiable_linkable_specs=list(satisfiable_metric_time_specs),
                        join_on_partition_dimensions=(),
                        join_on_partition_time_dimensions=(),
                        join_type=SqlJoinType.CROSS_JOIN,
                    )
                )
                continue

            entity_specs_in_right_node = data_set_in_right_node.instance_set.spec_set.entity_specs

            # For each unlinked entity in the data set, create a candidate for joining.
            # For a data set to be useful for satisfying a linkable spec, it needs to have the entity
            # and the linkable spec without the entity. This allows joining based on the entity, which will
            # then produce the linkable spec. See comments further below for more details.

            for entity_spec_in_right_node in entity_specs_in_right_node:
                entity_instance_in_right_node = None
                for instance in data_set_in_right_node.instance_set.entity_instances:
                    if instance.spec == entity_spec_in_right_node:
                        entity_instance_in_right_node = instance
                        break

                if entity_instance_in_right_node is None:
                    raise RuntimeError(f"Could not find entity instance with name ({entity_spec_in_right_node})")

                assert (
                    len(entity_instance_in_right_node.defined_from) == 1
                ), f"Did not get exactly 1 defined_from in {entity_instance_in_right_node}"

                entity_in_right_node = self._semantic_model_lookup.get_entity_in_semantic_model(
                    entity_instance_in_right_node.defined_from[0]
                )
                if entity_in_right_node is None:
                    raise RuntimeError(
                        f"Invalid SemanticModelElementReference {entity_instance_in_right_node.defined_from[0]}"
                    )

                entity_instance_in_left_node = None
                for instance in left_node_instance_set.entity_instances:
                    if instance.spec.reference == entity_spec_in_right_node.reference:
                        entity_instance_in_left_node = instance
                        break

                if entity_instance_in_left_node is None:
                    # The right node can have a superset of entities.
                    continue

                assert len(entity_instance_in_left_node.defined_from) == 1
                assert len(entity_instance_in_right_node.defined_from) == 1

                entity_spec_matches_aggregated_specs = {
                    spec.reference for spec in right_node.aggregated_to_elements
                } == {entity_spec_in_right_node.reference}
                if not (
                    self._join_evaluator.is_valid_semantic_model_join(
                        left_semantic_model_reference=entity_instance_in_left_node.defined_from[
                            0
                        ].semantic_model_reference,
                        right_semantic_model_reference=entity_instance_in_right_node.defined_from[
                            0
                        ].semantic_model_reference,
                        on_entity_reference=entity_spec_in_right_node.reference,
                    )
                    or entity_spec_matches_aggregated_specs
                ):
                    continue

                linkless_entity_spec_in_node = LinklessEntitySpec.from_element_name(
                    entity_spec_in_right_node.element_name
                )

                satisfiable_linkable_specs = []
                for needed_linkable_spec in needed_linkable_specs:
                    if len(needed_linkable_spec.entity_links) == 0:
                        assert (
                            needed_linkable_spec.element_name == METRIC_TIME_ELEMENT_NAME
                        ), "Only metric_time should have 0 entity links."
                        continue

                    # If the entity in the data set matches the link, then it can be used for joins. For example,
                    # if the node has the entity "user_id", and dimension "country" then it can be used for
                    # satisfying "user_id__country".
                    #
                    # Multi-hop example:
                    # required_linkable_spec = "user_id__device_id__platform"
                    # entity_spec_in_data_set = "user_id"
                    #
                    # Then the data set must contain "device_id__platform", which is realized with
                    #
                    # required_linkable_spec.remove_first_entity_link()
                    #
                    # We might also need to check the entity type and see if it's the type of join we're allowing,
                    # but since we're doing all left joins now, it's been left out.

                    required_entity_matches_data_set_entity = (
                        LinklessEntitySpec.from_reference(needed_linkable_spec.entity_links[0])
                        == linkless_entity_spec_in_node
                    )
                    needed_linkable_spec_in_node = (
                        needed_linkable_spec.without_first_entity_link in linkable_specs_in_right_node
                    )
                    if required_entity_matches_data_set_entity and needed_linkable_spec_in_node:
                        satisfiable_linkable_specs.append(needed_linkable_spec)

                # If this node can satisfy some linkable specs, it could be useful to join on, so add it to the
                # candidate list.
                if len(satisfiable_linkable_specs) > 0:
                    join_on_partition_dimensions = self._partition_resolver.resolve_partition_dimension_joins(
                        left_node_spec_set=left_node_spec_set,
                        node_to_join_spec_set=data_set_in_right_node.instance_set.spec_set,
                    )
                    join_on_partition_time_dimensions = self._partition_resolver.resolve_partition_time_dimension_joins(
                        left_node_spec_set=left_node_spec_set,
                        node_to_join_spec_set=data_set_in_right_node.instance_set.spec_set,
                    )
                    validity_window_join_description = CreateValidityWindowJoinDescription(
                        self._semantic_model_lookup
                    ).transform(instance_set=data_set_in_right_node.instance_set)

                    candidates_for_join.append(
                        JoinLinkableInstancesRecipe(
                            node_to_join=right_node,
                            join_on_entity=linkless_entity_spec_in_node,
                            satisfiable_linkable_specs=satisfiable_linkable_specs,
                            join_on_partition_dimensions=join_on_partition_dimensions,
                            join_on_partition_time_dimensions=join_on_partition_time_dimensions,
                            validity_window=validity_window_join_description,
                            join_type=default_join_type,
                        )
                    )

        # Return with the candidate set that can satisfy the most linkable specs at the front.
        return sorted(
            candidates_for_join,
            key=lambda x: len(x.satisfiable_linkable_specs),
            reverse=True,
        )

    @staticmethod
    def _update_candidates_that_can_satisfy_linkable_specs(
        candidates_for_join: List[JoinLinkableInstancesRecipe],
        already_satisfisfied_linkable_specs: List[LinkableInstanceSpec],
    ) -> List[JoinLinkableInstancesRecipe]:
        """Update / filter candidates_for_join based on linkable instance specs that we have already satisfied.

        Those linkable instances are no longer needed because those were satisfied previously by joining a node
        containing some needed linkable instances to the "left_node". This method will then remove the satisfied
        linkable instances from the candidate recipes, and if a candidate recipe doesn't have any linkable instances
        that can help satisfy the query, it is removed.
        """
        updated_candidate_data_sets: List[JoinLinkableInstancesRecipe] = []
        for candidate_for_join in candidates_for_join:
            updated_satisfiable_linkable_specs = list(
                set(candidate_for_join.satisfiable_linkable_specs) - set(already_satisfisfied_linkable_specs)
            )

            if len(updated_satisfiable_linkable_specs) > 0:
                updated_candidate_data_sets.append(
                    JoinLinkableInstancesRecipe(
                        node_to_join=candidate_for_join.node_to_join,
                        join_on_entity=candidate_for_join.join_on_entity,
                        satisfiable_linkable_specs=updated_satisfiable_linkable_specs,
                        join_on_partition_dimensions=candidate_for_join.join_on_partition_dimensions,
                        join_on_partition_time_dimensions=candidate_for_join.join_on_partition_time_dimensions,
                        validity_window=candidate_for_join.validity_window,
                        join_type=candidate_for_join.join_type,
                    )
                )
        return sorted(
            updated_candidate_data_sets,
            key=lambda x: len(x.satisfiable_linkable_specs),
            reverse=True,
        )

    def evaluate_node(
        self,
        left_node: DataflowPlanNode,
        required_linkable_specs: Sequence[LinkableInstanceSpec],
        default_join_type: SqlJoinType,
    ) -> LinkableInstanceSatisfiabilityEvaluation:
        """Evaluates if the "required_linkable_specs" can be realized by joining the "left_node" with other nodes.

        In other words, given the data set associated with "left_node":

        * Can all "required_linkable_specs" be retrieved from the left_node? (These would be considered "local").
        * If not, can they be retrieved by joining an available node though a common entity?
        * If so, return all possible ways (by joining different nodes) that can be done.
        """
        candidate_instance_set: InstanceSet = self._node_data_set_resolver.get_output_data_set(left_node).instance_set
        candidate_spec_set = candidate_instance_set.spec_set

        logger.debug(LazyFormat(lambda: f"Candidate spec set is:\n{mf_pformat(candidate_spec_set)}"))

        data_set_linkable_specs = candidate_spec_set.linkable_specs

        # These are linkable specs in the start node data set. Those are considered "local".
        local_linkable_specs: List[LinkableInstanceSpec] = []

        # These are linkable specs that aren't in the data set, but they might be able to be joined in.
        possibly_joinable_linkable_specs: List[LinkableInstanceSpec] = []

        # Group required_linkable_specs into local / un-joinable / or possibly joinable.
        unjoinable_linkable_specs = []
        for required_linkable_spec in required_linkable_specs:
            is_metric_time = required_linkable_spec.element_name == DataSet.metric_time_dimension_name()
            is_local = required_linkable_spec in data_set_linkable_specs
            is_unjoinable = (
                # metric_time is never unjoinable. In metric queries, the agg_time_dimension is local to the measure source node.
                # In no-metric queries, can always CROSS JOIN to a time spine.
                (not is_metric_time)
                and (
                    # metric_time is the only element that can be joined without entity links.
                    len(required_linkable_spec.entity_links) == 0
                    # In order be joinable, the first entity link must be in the left node's dataset.
                    or LinklessEntitySpec.from_reference(required_linkable_spec.entity_links[0])
                    not in data_set_linkable_specs
                )
            )
            if is_local:
                local_linkable_specs.append(required_linkable_spec)
            elif is_unjoinable:
                unjoinable_linkable_specs.append(required_linkable_spec)
            else:
                possibly_joinable_linkable_specs.append(required_linkable_spec)

        candidates_for_join = self._find_joinable_candidate_nodes_that_can_satisfy_linkable_specs(
            left_node_instance_set=candidate_instance_set,
            needed_linkable_specs=possibly_joinable_linkable_specs,
            default_join_type=default_join_type,
        )
        join_candidates: List[JoinLinkableInstancesRecipe] = []

        logger.debug(LazyFormat(lambda: "Looping over nodes that can be joined to get the required linkable specs"))

        # Using a greedy approach, try to get the "possibly_joinable_linkable_specs" by iteratively joining nodes with
        # the most matching linkable specs. We try to join nodes with the most matching specs to minimize the number of
        # joins that we have to do to. A knapsack solution is ideal, but punting on that for simplicity.
        while len(possibly_joinable_linkable_specs) > 0:
            logger.debug(
                LazyFormat(lambda: f"Looking for linkable specs:\n{mf_pformat(possibly_joinable_linkable_specs)}")
            )

            # We've run out of candidate data sets, but there are more linkable specs that we need. That means the
            # rest of the linkable specs can't be joined in, and we're left with unjoinable specs remaining.
            if len(candidates_for_join) == 0:
                logger.debug(
                    LazyFormat(
                        lambda: "There are no more candidate nodes that can be joined, but not all linkable specs have "
                        "been acquired."
                    )
                )
                unjoinable_linkable_specs.extend(possibly_joinable_linkable_specs)
                break

            # Join the best candidate to realize the linkable specs
            next_candidate = candidates_for_join.pop(0)
            logger.debug(LazyFormat(lambda: f"The next candidate node to be joined is:\n{mf_pformat(next_candidate)}"))
            join_candidates.append(next_candidate)

            # Update the candidates. Since we'll be joined/ing the previously selected candidate, we no longer need
            # to get those linkable specs from the remaining candidates, and we also need to re-rank based on the new
            # requirements.
            candidates_for_join = self._update_candidates_that_can_satisfy_linkable_specs(
                candidates_for_join=candidates_for_join,
                already_satisfisfied_linkable_specs=next_candidate.satisfiable_linkable_specs,
            )

            # The once possibly joinable specs are definitely joinable and no longer need to be searched for.
            # Remove from "possibly_joinable_linkable_specs"
            possibly_joinable_linkable_specs = [
                x for x in possibly_joinable_linkable_specs if x not in next_candidate.satisfiable_linkable_specs
            ]

        logger.debug(LazyFormat(lambda: "Done evaluating possible joins"))
        return LinkableInstanceSatisfiabilityEvaluation(
            local_linkable_specs=tuple(local_linkable_specs),
            joinable_linkable_specs=tuple(
                itertools.chain.from_iterable([x.satisfiable_linkable_specs for x in join_candidates])
            ),
            join_recipes=tuple(join_candidates),
            unjoinable_linkable_specs=tuple(unjoinable_linkable_specs),
        )
