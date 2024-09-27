import logging
from abc import ABC, abstractmethod
from typing import Any, Callable, Dict, List, Literal, Optional, Set, Type, Union

from pydantic import BaseModel, ConfigDict

from flexisearch.llm.config import LLMConfig
from flexisearch.llm.llm import LLM
from flexisearch.llm.structured_schema import FxLLMStructuredSchema
from flexisearch.prompt import PromptTemplate

logger = logging.getLogger(__name__)


class FxTaskEntity(FxLLMStructuredSchema):
    def __repr__(self):
        field_strings = [f"{key}: {value}" for key, value in self.model_dump().items()]
        return "\n".join(field_strings)


class FxTaskNodeInputTaken(FxTaskEntity):
    input: str


class FxTaskActionLLMParams(BaseModel):
    llm_config: LLMConfig
    instruction: str


def get_simple_gpt_4o_mini_action(instruction: str) -> FxTaskActionLLMParams:
    return FxTaskActionLLMParams(
        llm_config=LLMConfig(engine="OpenAI", params={"openai_model": "gpt-4o-mini"}),
        instruction=instruction,
    )


FxTaskActionFunction = Callable[[Dict[str, Any]], Any]


class FxTaskAction(BaseModel):
    type: Literal["llm", "function", "agent"]
    params: Union[
        Dict[str, Any], FxTaskActionLLMParams, FxTaskActionFunction, "FxTaskAgent"
    ]

    model_config = ConfigDict(arbitrary_types_allowed=True)


class FxTaskConfig(BaseModel):
    task_key: str
    input_schema: Dict[str, Type[Union[FxTaskEntity, str]]]
    output_schema: Type[Union[FxTaskEntity, str]]
    action: Union[Dict[str, Any], FxTaskAction]
    print_details: bool = False


class FxTask(ABC):
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


class FxTaskNode(FxTask):
    def __init__(
        self,
        config: FxTaskConfig,
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
    def config(self) -> FxTaskConfig:
        return self._config

    def _require_input(
        self,
        kwargs: dict[str, Any],
        key: str,
        message: Optional[str] = None,
        value_type: Optional[Type[Any]] = None,
    ) -> Any:
        if not message:
            message = f"task[{self.__class__.__name__}] input must has field {key}"
        assert key in kwargs, message
        if value_type is not None:
            assert isinstance(kwargs[key], value_type)
        return kwargs[key]

    def _process_llm(self, _action: FxTaskAction, _inputs: Dict[str, Any]) -> Any:
        if isinstance(_action.params, FxTaskActionLLMParams):
            params = _action.params
        elif isinstance(_action.params, dict):
            params = FxTaskActionLLMParams(**_action.params)
        else:
            raise TypeError(f"action params type not match. {_action.params}")

        llm = LLM(params.llm_config)
        if issubclass(self.config.output_schema, FxTaskEntity):
            prompt = PromptTemplate(
                prompt="Assist user with the task with structure output",
                user_question_prompt=params.instruction,
            )
            response = llm.chat_completion_with_structured_output(
                prompt=prompt,
                variables=_inputs,
                response_format=self.config.output_schema,
            )
        elif self.config.output_schema is str:
            prompt = PromptTemplate(
                prompt="You are a helpful assistant",
                user_question_prompt=params.instruction,
            )
            response = llm.chat_completion(prompt=prompt, variables=_inputs)
        return response

    def _process_function(self, _action: FxTaskAction, _inputs: Dict[str, Any]) -> Any:
        if callable(_action.params):
            func = _action.params
        else:
            raise TypeError(f"action params type not match. {_action.params}")
        return func(_inputs)

    def _process_agent(self, _action: FxTaskAction, _inputs: Dict[str, Any]) -> Any:
        if isinstance(_action.params, FxTaskAgent):
            task = _action.params
        else:
            raise TypeError(f"action params type not match. {_action.params}")
        return task.invoke(**_inputs)

    def process(self, *args: Any, **kwds: Any) -> Any:
        processor_mapping = {
            "llm": self._process_llm,
            "function": self._process_function,
            "agent": self._process_agent,
        }
        action = self.config.action
        if isinstance(action, dict):
            action = FxTaskAction(**action)
        elif isinstance(action, FxTaskAction):
            pass
        else:
            raise TypeError(f"action type not match. {action}")

        inputs = {}
        for key, _type in self.config.input_schema.items():
            inputs[key] = self._require_input(kwargs=kwds, key=key, value_type=_type)

        if action.type in processor_mapping:
            if self.config.print_details:
                logger.info(f"\nInput:\n{inputs}")
            response = processor_mapping[action.type](action, inputs)
            if self.config.print_details:
                logger.info(f"\nOutput:\n{response}")
        else:
            raise ValueError(f"action not support. f{self.config.action}")

        return response


class FxTaskAgent:
    def __init__(
        self,
        task_graph: List[FxTaskConfig],
        *,
        preprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
        postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
    ):
        self.tasks = self._build_task_graph(task_graph)
        self.preprocess_hook = preprocess_hook
        self.postprocess_hook = postprocess_hook

    def _build_task_graph(self, task_graph: List[FxTaskConfig]) -> List[FxTaskNode]:
        def build_graph(config_list: List[FxTaskConfig]) -> Dict[str, FxTaskNode]:
            graph_dict: Dict[str, FxTaskNode] = {}
            for config in config_list:
                graph_dict[config.task_key] = FxTaskNode(config)
            return graph_dict

        def topo_sort(node_graph: Dict[str, FxTaskNode]) -> List[FxTaskNode]:
            visited: Set[str] = set()
            temp_marked: Set[str] = set()
            stack: List[FxTaskNode] = []

            def dfs(node: FxTaskNode):
                if node.config.task_key in temp_marked:
                    raise ValueError("Graph is not a DAG")

                if node.config.task_key in visited:
                    return

                temp_marked.add(node.config.task_key)
                for neighbor_key, _ in node.config.input_schema.items():
                    if neighbor_key in node_graph:
                        neighbor = node_graph[neighbor_key]
                        dfs(neighbor)
                temp_marked.remove(node.config.task_key)
                visited.add(node.config.task_key)
                stack.append(node)

            for _, node in node_graph.items():
                dfs(node)

            return stack

        node_graph = build_graph(task_graph)
        sorted_nodes = topo_sort(node_graph)
        logger.info([(idx, n.config.task_key) for idx, n in enumerate(sorted_nodes)])
        return sorted_nodes

    def invoke(self, *args: Any, **kwds: Any) -> Any:
        context: Dict[str, Union[FxTaskEntity, str]] = {}
        if "input" not in kwds:
            for arg in args:
                if isinstance(arg, (FxTaskEntity, str)):
                    context["input"] = arg
        for key, value in kwds.items():
            context[key] = value

        # preprocess
        if self.preprocess_hook:
            context = self.preprocess_hook(context)

        # run task dag
        for task in self.tasks:
            if task.config.print_details:
                logger.info(f"Step: {task.config.task_key}")
            output = task.invoke(**context)
            context[task.config.task_key] = output

        # postprocess
        if self.postprocess_hook:
            context = self.postprocess_hook(context)

        if "output" in context:
            return context["output"]
