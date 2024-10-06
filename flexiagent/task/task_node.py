import logging
from typing import Any, Callable, Dict, List, Optional, Set, Tuple, Type, Union

from flexiagent.llm.llm import LLM
from flexiagent.prompts.prompt import PromptTemplate
from flexiagent.task.action_loader import ActionLoader
from flexiagent.task.base import (
    TaskAction,
    TaskActionContext,
    TaskActionLLM,
    TaskAgent,
    TaskBase,
    TaskConfig,
    TaskEntity,
)
from flexiagent.task.condition import ConditionExecutor, TaskActionAbort

logger = logging.getLogger(__name__)


class TaskNode(TaskBase):
    def __init__(
        self,
        config: TaskConfig,
        *,
        preprocess_hook: Optional[Callable] = None,
        postprocess_hook: Optional[Callable] = None,
    ):
        super().__init__(
            preprocess_hook=preprocess_hook,
            postprocess_hook=postprocess_hook,
        )
        self._config = config

    @property
    def config(self) -> TaskConfig:
        return self._config

    def _require_input(
        self,
        kwargs: Dict[str, Any],
        key: str,
        message: Optional[str] = None,
        value_type: Optional[Type[Any]] = None,
    ) -> Any:
        if not message:
            message = f"task[{self.__class__.__name__}] input must has field {key}"
        assert key in kwargs, message
        if (value_type is not None) and (not isinstance(kwargs[key], TaskActionAbort)):
            if not isinstance(kwargs[key], value_type):
                raise TypeError(
                    f"""_require_input:
key={key} type={type(kwargs[key])} not match {value_type}
----------
{kwargs[key]}
"""
                )
        return kwargs[key]

    def _process_llm(self, _action: TaskAction, _inputs: Dict[str, Any]) -> Any:
        if isinstance(_action.act, TaskActionLLM):
            params = _action.act
        elif isinstance(_action.act, str):
            params = ActionLoader.load_llm(_action.act)
        else:
            raise TypeError(f"action params type not match. {_action.act}")

        llm = LLM(params.llm_config)
        if issubclass(self.config.output_schema, TaskEntity):
            prompt = PromptTemplate(
                prompt="You are a helpful assistant that assist users in completing tasks and use formatted output.",
                user_question_prompt=params.instruction,
            )
            response = llm.chat_completion_with_structured_output(
                prompt=prompt,
                variables=_inputs,
                response_format=self.config.output_schema,
            )
        elif self.config.output_schema is str:
            prompt = PromptTemplate(
                prompt="You are a helpful assistant.",
                user_question_prompt=params.instruction,
            )
            response = llm.chat_completion(prompt=prompt, variables=_inputs)
        else:
            raise TypeError(f"Output schema not support, {self.config.output_schema}")
        return response

    def _process_function(self, _action: TaskAction, _inputs: Dict[str, Any]) -> Any:
        if callable(_action.act):
            fn = _action.act
        elif isinstance(_action.act, str):
            fn = ActionLoader.load_function(_action.act)
        else:
            raise TypeError(f"action params type not match. {_action.act}")
        addition: Dict[str, Any] = {}
        if _action.addition:
            addition = {k: v for k, v in _action.addition.items()}
        ctx: TaskActionContext = {
            "config": self.config,
        }
        return fn(ctx, _inputs, addition)

    def _process_agent(self, _action: TaskAction, _inputs: Dict[str, Any]) -> Any:
        if isinstance(_action.act, TaskAgent):
            agent = _action.act
        elif isinstance(_action.act, str):
            agent = ActionLoader.load_agent(_action.act)
        else:
            raise TypeError(f"action params type not match. {_action.act}")
        return agent.invoke(**_inputs)

    def process(self, *args: Any, **kwds: Any) -> Any:
        processor_mapping = {
            "llm": self._process_llm,
            "function": self._process_function,
            "agent": self._process_agent,
        }
        action = self.config.action
        if isinstance(action, dict):
            action = TaskAction(**action)
        elif isinstance(action, TaskAction):
            pass
        else:
            raise TypeError(f"action type not match. {action}")

        # setup inputs from context
        inputs = {}
        for key, _type in self.config.input_schema.items():
            inputs[key] = self._require_input(kwargs=kwds, key=key, value_type=_type)

        # process condition
        if action.condition:
            executor = ConditionExecutor(action.condition)
            is_abort = executor(inputs)
            if is_abort:
                return is_abort

        # execute task with inputs
        if action.type in processor_mapping:
            response = processor_mapping[action.type](action, inputs)
        else:
            raise ValueError(f"action not support. f{self.config.action}")

        # check the output schema match or not
        if not isinstance(response, self.config.output_schema):
            raise TypeError(
                f"Output type not match, output: {type(response)} schema: {self.config.output_schema}"
            )

        return response
