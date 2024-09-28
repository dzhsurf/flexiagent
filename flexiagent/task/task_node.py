import logging
from typing import Any, Callable, Dict, List, Literal, Optional, Set, Type, Union

from pydantic import BaseModel, ConfigDict

from flexiagent.llm.config import LLMConfig
from flexiagent.llm.llm import LLM
from flexiagent.llm.structured_schema import FxLLMStructuredSchema
from flexiagent.prompts.prompt import PromptTemplate
from flexiagent.task.base import FxTask

logger = logging.getLogger(__name__)


class FxTaskActionLLM(BaseModel):
    llm_config: LLMConfig
    instruction: str


FxTaskActionFunction = Callable[[Dict[str, Any]], Any]


class FxTaskAction(BaseModel):
    type: Literal["llm", "function", "agent"]
    act: Union[
        FxTaskActionLLM,
        FxTaskActionFunction,
        "FxTaskAgent",
    ]

    model_config = ConfigDict(arbitrary_types_allowed=True)


class FxTaskEntity(FxLLMStructuredSchema):
    def __repr__(self):
        field_strings = [f"{key}: {value}" for key, value in self.model_dump().items()]
        return "\n".join(field_strings)


class FxTaskConfig(BaseModel):
    task_key: str
    input_schema: Dict[str, Type[Union[FxTaskEntity, str]]]
    output_schema: Type[Union[FxTaskEntity, str]]
    action: FxTaskAction


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
        kwargs: Dict[str, Any],
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
        if isinstance(_action.act, FxTaskActionLLM):
            params = _action.act
        else:
            raise TypeError(f"action params type not match. {_action.act}")

        llm = LLM(params.llm_config)
        if issubclass(self.config.output_schema, FxTaskEntity):
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
        return response

    def _process_function(self, _action: FxTaskAction, _inputs: Dict[str, Any]) -> Any:
        if callable(_action.act):
            fn = _action.act
        else:
            raise TypeError(f"action params type not match. {_action.act}")
        return fn(_inputs)

    def _process_agent(self, _action: FxTaskAction, _inputs: Dict[str, Any]) -> Any:
        if isinstance(_action.act, FxTaskAgent):
            agent = _action.act
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
            action = FxTaskAction(**action)
        elif isinstance(action, FxTaskAction):
            pass
        else:
            raise TypeError(f"action type not match. {action}")

        # setup inputs from context
        inputs = {}
        for key, _type in self.config.input_schema.items():
            inputs[key] = self._require_input(kwargs=kwds, key=key, value_type=_type)

        # execute task with inputs
        if action.type in processor_mapping:
            response = processor_mapping[action.type](action, inputs)
        else:
            raise ValueError(f"action not support. f{self.config.action}")

        return response


class FxTaskAgent:
    def __init__(
        self,
        *,
        task_graph: List[Union[FxTaskConfig, FxTaskNode]],
        preprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
        postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
    ):
        self.tasks = self._build_task_graph(task_graph)
        self.preprocess_hook = preprocess_hook
        self.postprocess_hook = postprocess_hook

    def _build_graph(
        self, item_list: List[Union[FxTaskConfig, FxTaskNode]]
    ) -> Dict[str, FxTaskNode]:
        graph_dict: Dict[str, FxTaskNode] = {}
        for item in item_list:
            if isinstance(item, FxTaskConfig):
                graph_dict[item.task_key] = FxTaskNode(item)
            elif isinstance(item, FxTaskNode):
                graph_dict[item.config.task_key] = item
        return graph_dict

    def _topo_sort(self, node_graph: Dict[str, FxTaskNode]) -> List[FxTaskNode]:
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

    def _build_task_graph(
        self, config_items: List[Union[FxTaskConfig, FxTaskNode]]
    ) -> List[FxTaskNode]:
        node_graph = self._build_graph(config_items)
        sorted_nodes = self._topo_sort(node_graph)
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
            logger.debug(f"Step: {task.config.task_key}")
            output = task.invoke(**context)
            context[task.config.task_key] = output

        # postprocess
        if self.postprocess_hook:
            context = self.postprocess_hook(context)

        if "output" in context:
            return context["output"]
