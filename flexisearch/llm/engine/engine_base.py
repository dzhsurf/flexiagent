from abc import ABC, abstractmethod
from typing import Dict, Generic, Type, TypeVar

from pydantic import BaseModel

from flexisearch.prompt import PromptTemplate, PromptValue


class LLMEngineConfig(BaseModel):
    pass


T = TypeVar("T", bound=LLMEngineConfig)


class LLMEngine(ABC, Generic[T]):
    def __init__(self, config: T) -> None:
        pass

    @classmethod
    @abstractmethod
    def engine_name(cls) -> str:
        pass

    @classmethod
    @abstractmethod
    def config_cls(cls) -> Type[T]:
        pass

    @abstractmethod
    def query(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ) -> str:
        pass


class LLMEngineImpl(LLMEngine[T], Generic[T]):
    def __init__(self, config: T):
        self.config = config
        if not isinstance(config, self.config_cls()):
            raise TypeError(
                f"Config is not match LLMEngine. {type(config)} | {self.config_cls()}"
            )

    @classmethod
    def engine_name(cls) -> str:
        raise NotImplementedError("Subclasses should implement this.")

    @classmethod
    def config_cls(cls) -> Type[T]:
        raise NotImplementedError("Subclasses should implement this.")
