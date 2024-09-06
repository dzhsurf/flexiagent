from typing import Any, Dict, List

from flexisearch.agent import FxAgent, FxAgentRunnerConfig
from flexisearch.agents.agent_intent_recognition import \
    FxAgentIntentRecognition
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
        # match intention
        match_intentions = self._match_intention(
            input, [item for _, item in self.agents.items()]
        )

        # invoke agent
        for intention in match_intentions:
            result = intention.invoke(
                FxAgentRunnerConfig(
                    llm=self.llm,
                    indexer=self.indexer,
                ),
                input,
            )
            if result.stop:
                return result.value
        else:
            pass

        return ""

    def _match_intention(
        self, input: str, agents: List[FxAgent[Any, Any]]
    ) -> List[FxAgent[Any, Any]]:
        # TODO: intent

        agent = FxAgentIntentRecognition()
        agent.invoke(FxAgentRunnerConfig(llm=self.llm, indexer=self.indexer), agents)

        # self.llm.query(
        #     PROMPT_TEMPLATE_INTENT_RECOGNITION,
        #     variables={
        #         "input": str(input),
        #         "actions": "",
        #     },
        # )

        return []

    # def _query_understanding(self, text: str) -> StructuredInput:
    #     # case 1: not applicable.
    #     # searcher.assist(
    #     #   "can you help me do the math problem: x, y, z."
    #     # )
    #     # query understable
    #     # accept intention , not accept ....
    #     # (## .... example, description: metadata, purpose, ), {QA}

    #     # tool chain
    #     # searcher.register(tool, description)

    #     # searcher.match_intention
    #     #  prompt
    #     #   you have tools:
    #     # 1: SQL2Text parser, this tool is good for matching query query to express it in sql format,
    #     # 2: Embedding required, ....
    #     # 3: # f,dl.af
    #     # not application.
