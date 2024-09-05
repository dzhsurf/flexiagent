from typing import Any, Dict, List, Protocol, Union
from dataclasses import dataclass
from flexisearch.indexer import FxIndexer
from flexisearch.llm import LLM


@dataclass
class FxAgentRunnerConfig:
    llm: LLM
    indexer: FxIndexer


FxAgentRunnerValue = Union[str, Dict[str, Any]]


@dataclass
class FxAgentRunnerResult:
    stop: bool
    error_msg: str
    value: FxAgentRunnerValue


class FxAgentRunner(Protocol):
    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentRunnerValue,
    ) -> FxAgentRunnerResult:
        pass


class FxAgent(FxAgentRunner):
    name: str
    description: str

    def __init__(self, name: str, description: str):
        super().__init__()
        self.name = name
        self.description = description


class FxAgentChain(FxAgent):
    agents: List[FxAgent]

    def __init__(self, name: str, description: str, agents: List[FxAgent]) -> None:
        super().__init__(name, description)
        self.agents = agents

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentRunnerValue,
    ) -> FxAgentRunnerResult:
        pre_result = FxAgentRunnerResult(
            stop=False,
            error_msg="No agents",
            value=input,
        )

        # invoke chain
        for agent in self.agents:
            result = agent.invoke(configure, pre_result.value)
            if result.stop:
                return result
            pre_result = result

        return pre_result
