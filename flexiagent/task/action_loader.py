from flexiagent.builtin.function.http_call import builtin_http_call
from flexiagent.task.base import TaskActionFunction, TaskActionLLM, TaskAgentBase


class ActionLoader:
    @classmethod
    def load_function(self, name: str) -> TaskActionFunction:
        if name == "builtin.http_call":
            return builtin_http_call
        raise ValueError(f"Unsupport function name, {name}")

    @classmethod
    def load_agent(cls, name: str) -> TaskAgentBase:
        raise ValueError(f"Unsupport agent name, {name}")

    @classmethod
    def load_llm(cls, name: str) -> TaskActionLLM:
        raise ValueError(f"Unsupport llm name, {name}")
