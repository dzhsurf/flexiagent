import os
from abc import ABC, abstractmethod
from typing import Dict, Generic, Optional, Type, TypeVar

from pydantic import BaseModel, Field

from flexiagent.config_keys import LLM_HTTP_API_TIMEOUT
from flexiagent.llm.structured_schema import FxLLMStructuredSchema
from flexiagent.prompts.prompt import PromptTemplate, PromptValue


def get_env_variable(var_name: str, default: str = "") -> str:
    return os.environ.get(var_name, default)


class LLMEngineConfig(BaseModel):
    timeout: Optional[float] = Field(
        default_factory=lambda: float(get_env_variable(LLM_HTTP_API_TIMEOUT, "5"))
    )


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
    def chat_completion(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ) -> str:
        pass

    @abstractmethod
    def chat_completion_with_structured_output(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
        response_format: Type[FxLLMStructuredSchema] = FxLLMStructuredSchema,
    ) -> FxLLMStructuredSchema:
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
