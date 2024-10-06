import logging
from typing import Any, Callable, Dict, List, Optional, Set, Tuple, Union

from flexiagent.task.base import TaskAgentBase, TaskConfig, TaskEntity
from flexiagent.task.task_node import TaskNode

logger = logging.getLogger(__name__)


class TaskAgent(TaskAgentBase):
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
