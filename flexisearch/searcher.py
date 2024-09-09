import logging
from typing import Any, Dict, List, Optional

from flexisearch.agent import FxAgent, FxAgentInput, FxAgentRunnerConfig
from flexisearch.agents.agent_intent_recognizer import (
    FxAgentIntentRecognizer,
    FxAgentIntentRecognizerInput,
)
from flexisearch.indexer import FxIndexer
from flexisearch.llm.config import LLMConfig
from flexisearch.llm.llm import LLM

logger = logging.getLogger(__name__)


class FxSearcher:
    def __init__(self, llm_config: LLMConfig, indexer: FxIndexer):
        self.llm = LLM(llm_config)
        self.indexer = indexer
        self.agents: Dict[str, FxAgent[FxAgentInput, Any]] = {}

    def register(self, agent: FxAgent[Any, Any]):
        self.agents[agent.name] = agent

    def assist(self, input: str) -> str:
        # match agent
        match_agent = self._match_intention(
            input, [item for _, item in self.agents.items()]
        )
        if match_agent:
            result = match_agent.invoke(
                FxAgentRunnerConfig(self.llm, self.indexer),
                match_agent.construct_input(input),
            )
            return str(result.value)

        return "Not Application"

    def _match_intention(
        self, input: str, agents: List[FxAgent[Any, Any]]
    ) -> Optional[FxAgent[FxAgentInput, Any]]:
        agent = FxAgentIntentRecognizer()
        result = agent.invoke(
            FxAgentRunnerConfig(llm=self.llm, indexer=self.indexer),
            FxAgentIntentRecognizerInput(input=input, agents=agents),
        )

        if len(result.value) > 0:
            return result.value[0]

        return None
