from typing import Any, Dict, List

from flexisearch.agent import FxAgent, FxAgentRunnerConfig
from flexisearch.agents.agent_intent_recognizer import (
    FxAgentIntentRecognizer, FxAgentIntentRecognizerInput)
from flexisearch.indexer import FxIndexer
from flexisearch.llm import LLM


class FxSearcher:
    llm: LLM
    indexer: FxIndexer
    agents: Dict[str, FxAgent]

    def __init__(self, indexer: FxIndexer):
        self.llm = LLM()
        self.indexer = indexer
        self.agents = {}

    def register(self, agent: FxAgent):
        self.agents[agent.name] = agent

    def assist(self, input: str) -> str:
        # match agent
        match_agents = self._match_intention(
            input, [item for _, item in self.agents.items()]
        )

        # invoke agent, TODO, only pick one
        if len(match_agents) > 0:
            result = match_agents[0].invoke(
                FxAgentRunnerConfig(self.llm, self.indexer), input
            )
            return str(result.value)

        return "Not Application"

    def _match_intention(
        self, input: str, agents: List[FxAgent[Any, Any]]
    ) -> List[FxAgent[Any, Any]]:
        agent = FxAgentIntentRecognizer()
        result = agent.invoke(
            FxAgentRunnerConfig(llm=self.llm, indexer=self.indexer),
            FxAgentIntentRecognizerInput(input=input, agents=agents),
        )

        return result.value
