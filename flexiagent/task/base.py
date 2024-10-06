from abc import ABC, abstractmethod
from typing import Any, Callable, Dict, Literal, Optional, Type, Union

from pydantic import BaseModel, ConfigDict
from typing_extensions import TypedDict

from flexiagent.llm.config import LLMConfig
from flexiagent.llm.structured_schema import StructuredSchema
from flexiagent.task.condition import Condition, TaskActionAbort


class TaskBase(ABC):
    def __init__(
        self,
        *,
        preprocess_hook: Optional[Callable] = None,
        postprocess_hook: Optional[Callable] = None,
    ):
        super().__init__()
        self.preprocess_hook = preprocess_hook
        self.postprocess_hook = postprocess_hook

    @abstractmethod
    def process(self, *args: Any, **kwds: Any) -> Any:
        pass

    def should_process(self, *args: Any, **kwds: Any) -> bool:
        return True

    def fallback_process(self, *args: Any, **kwds: Any) -> Any:
        return None

    def invoke(self, *args: Any, **kwds: Any):
        if self.preprocess_hook:
            args, kwds = self.preprocess_hook(*args, **kwds)

        if self.should_process(*args, **kwds):
            result = self.process(*args, **kwds)
            if self.postprocess_hook:
                result = self.postprocess_hook(result)
            return result
        else:
            return self.fallback_process(*args, **kwds)


class TaskEntity(StructuredSchema):
    def __repr__(self):
        field_strings = [f"{key}: {value}" for key, value in self.model_dump().items()]
        return "\n".join(field_strings)


class TaskActionContext(TypedDict):
    config: "TaskConfig"


TaskActionSchemaBaseObject = Union[str, None]
TaskActionSchemaObject = Union[TaskEntity, TaskActionSchemaBaseObject, TaskActionAbort]
TaskActionFunction = Callable[
    [TaskActionContext, Dict[str, Any], Dict[str, Any]], TaskActionSchemaObject
]


class TaskActionLLM(BaseModel):
    llm_config: LLMConfig
    instruction: str


class TaskAgent(ABC):
    @abstractmethod
    def invoke(self, *args: Any, **kwds: Any) -> Any:
        pass


class TaskAction(BaseModel):
    type: Literal["llm", "function", "agent"]
    act: Union[
        TaskActionLLM,
        TaskActionFunction,
        TaskAgent,
        str,
    ]
    addition: Optional[Dict[str, Any]] = None
    condition: Optional[Condition] = None

    model_config = ConfigDict(arbitrary_types_allowed=True)


class TaskConfig(BaseModel):
    task_key: str
    input_schema: Dict[str, Type[TaskActionSchemaObject]]
    output_schema: Type[TaskActionSchemaObject]
    action: TaskAction
