import logging
from typing import Any, Callable, Dict, List, Literal, Optional, Set, Tuple, Type, Union

from pydantic import BaseModel, ConfigDict

from flexiagent.llm.config import LLMConfig
from flexiagent.llm.llm import LLM
from flexiagent.llm.structured_schema import StructuredSchema
from flexiagent.prompts.prompt import PromptTemplate
from flexiagent.task.base import TaskBase
from flexiagent.task.condition import Condition, ConditionExecutor, TaskActionAbort

logger = logging.getLogger(__name__)


class TaskEntity(StructuredSchema):
    def __repr__(self):
        field_strings = [f"{key}: {value}" for key, value in self.model_dump().items()]
        return "\n".join(field_strings)


TaskActionSchemaBaseObject = Union[str, None]
TaskActionSchemaObject = Union[TaskEntity, TaskActionSchemaBaseObject, TaskActionAbort]
TaskActionFunction = Callable[[Dict[str, Any], Dict[str, Any]], TaskActionSchemaObject]


class TaskActionLLM(BaseModel):
    llm_config: LLMConfig
    instruction: str


class TaskAction(BaseModel):
    type: Literal["llm", "function", "agent"]
    act: Union[
        TaskActionLLM,
        TaskActionFunction,
        "TaskAgent",
    ]
    addition: Optional[Dict[str, Any]] = None
    condition: Optional[Condition] = None

    model_config = ConfigDict(arbitrary_types_allowed=True)


class TaskConfig(BaseModel):
    task_key: str
    input_schema: Dict[str, Type[TaskActionSchemaObject]]
    output_schema: Type[TaskActionSchemaObject]
    action: TaskAction


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
        else:
            raise TypeError(f"action params type not match. {_action.act}")
        addition: Dict[str, Any] = {}
        if _action.addition:
            addition = {k: v for k, v in _action.addition.items()}
        if "output_schema" not in addition:
            addition["output_schema"] = self.config.output_schema
        return fn(_inputs, addition)

    def _process_agent(self, _action: TaskAction, _inputs: Dict[str, Any]) -> Any:
        if isinstance(_action.act, TaskAgent):
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


class TaskAgent:
    def __init__(
        self,
        *,
        task_graph: List[Union[TaskConfig, TaskNode]],
        preprocess_hook: Optional[
            Callable[[Dict[str, Any]], Tuple[Dict[str, Any], bool]]
        ] = None,
        postprocess_hook: Optional[Callable[[Dict[str, Any]], Dict[str, Any]]] = None,
    ):
        self.tasks = self._build_task_graph(task_graph)
        self.preprocess_hook = preprocess_hook
        self.postprocess_hook = postprocess_hook

    def _build_graph(
        self, item_list: List[Union[TaskConfig, TaskNode]]
    ) -> Dict[str, TaskNode]:
        graph_dict: Dict[str, TaskNode] = {}
        for item in item_list:
            if isinstance(item, TaskConfig):
                graph_dict[item.task_key] = TaskNode(item)
            elif isinstance(item, TaskNode):
                graph_dict[item.config.task_key] = item
        return graph_dict

    def _topo_sort(self, node_graph: Dict[str, TaskNode]) -> List[TaskNode]:
        visited: Set[str] = set()
        temp_marked: Set[str] = set()
        stack: List[TaskNode] = []

        def dfs(node: TaskNode):
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
        self, config_items: List[Union[TaskConfig, TaskNode]]
    ) -> List[TaskNode]:
        # check input paramaters
        node_graph = self._build_graph(config_items)
        sorted_nodes = self._topo_sort(node_graph)
        logger.info([(idx, n.config.task_key) for idx, n in enumerate(sorted_nodes)])
        return sorted_nodes

    def invoke(self, *args: Any, **kwds: Any) -> Any:
        context: Dict[str, Union[TaskEntity, str]] = {}
        if "input" not in kwds:
            for arg in args:
                if isinstance(arg, (TaskEntity, str)):
                    context["input"] = arg
        for key, value in kwds.items():
            context[key] = value

        # preprocess
        if self.preprocess_hook:
            context, stop = self.preprocess_hook(context)
            if stop and "output" in context:
                return context["output"]

        # run task dag
        for task in self.tasks:
            logger.info(f"Step: {task.config.task_key}")
            try:
                output = task.invoke(**context)
                logger.info(f"Step: {task.config.task_key}\nOutput: {output}")
                context[task.config.task_key] = output
            except Exception as e:
                logger.error(e)

        # postprocess
        if self.postprocess_hook:
            context = self.postprocess_hook(context)

        if "output" in context:
            return context["output"]
