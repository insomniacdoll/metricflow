from __future__ import annotations

from dataclasses import dataclass

from dbt_semantic_interfaces.dataclass_serialization import SerializableDataclass
from dbt_semantic_interfaces.type_enums.time_granularity import TimeGranularity


@dataclass(frozen=True)
class ExpandedTimeGranularity(SerializableDataclass):
    """Dataclass container for custom granularity extensions to the base TimeGranularity enumeration.

    This includes the granularity name, which is either the custom granularity or the TimeGranularity string value,
    and an associated base time granularity value.

    For custom granularities, we use the base time granularity as a pointer to the base standard grain used to look
    up the time spine. For standard TimeGranularities the base_granularity is always the same as the TimeGranularity.

    This will allow us to continue to do comparisons for standard TimeGranularity values, and also to do some level of
    comparison between custom granularities.
    """

    name: str
    base_granularity: TimeGranularity

    def __post_init__(self) -> None:
        """Post init validation to ensure this class is configured correctly for standard time granularity values."""
        if ExpandedTimeGranularity.is_standard_granularity_name(self.name):
            assert TimeGranularity(self.name) == self.base_granularity, (
                f"Invalid configuration of ExpandedTimeGranularity for standard TimeGranularity with name {self.name}."
                f"This should correspond to a base_granularity of {TimeGranularity(self.name)}, but it has "
                f"{self.base_granularity}."
            )

    @property
    def is_custom_granularity(self) -> bool:  # noqa: D102
        return self.base_granularity.value != self.name

    @classmethod
    def from_time_granularity(cls, granularity: TimeGranularity) -> ExpandedTimeGranularity:
        """Factory method for creating an ExpandedTimeGranularity from a standard TimeGranularity enumeration value."""
        return ExpandedTimeGranularity(name=granularity.value, base_granularity=granularity)

    @staticmethod
    def is_standard_granularity_name(time_granularity_name: str) -> bool:
        """Helper for checking if a given time granularity name is part of the standard TimeGranularity enumeration."""
        for granularity in TimeGranularity:
            if time_granularity_name == granularity.value:
                return True

        return False