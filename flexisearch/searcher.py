from typing import Dict, List

from flexisearch.agent import FxAgent, FxAgentRunnerConfig, FxAgentRunnerValue
from flexisearch.indexer import FxIndexer
from flexisearch.llm import LLM
from flexisearch.prompts import PROMPT_TEMPLATE_INTENT_RECOGNITION


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

    def assist(self, input: FxAgentRunnerValue) -> FxAgentRunnerValue:
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

        # # step 2: text2sql, retrieval context data
        # # if structured_input.prompt_template_name == "text2sql":
        # sql_query = self._text2sql(query, self.indexer)
        # print("SQLQuery:", sql_query)
        # documents = self.indexer.retrieval_documents(sql_query)
        # print("Retrieval:", documents)
        # if len(documents) == 0:
        #     knowledge_context = "No search record."
        # else:
        #     knowledge_context = "\n".join(documents)
        # knowledge_context = f"SQL: {sql_query}\n---\n{knowledge_context}\n"

        # # step 3: construct response
        # return self._response_with_knowledge(query, knowledge_context)

    def _match_intention(
        self, input: FxAgentRunnerValue, agent: List[FxAgent]
    ) -> List[FxAgent]:
        # TODO: intent

        self.llm.query(
            PROMPT_TEMPLATE_INTENT_RECOGNITION,
            variables={
                "input": str(input),
                "actions": "",
            },
        )

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
