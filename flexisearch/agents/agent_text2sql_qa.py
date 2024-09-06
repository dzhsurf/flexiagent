from typing import Any, Callable, Optional, cast

from flexisearch.agent import FxAgentChain, FxAgentParseOutput, FxAgentRunnerConfig
from flexisearch.agents.agent_context_qa import FxAgentContextQA, FxAgentContextQAInput
from flexisearch.agents.agent_retriever import (
    FxAgentRetriever,
    FxAgentRetrieverInput,
    FxAgentRetrieverOutput,
)
from flexisearch.agents.agent_text2sql import FxAgentText2SQL, FxAgentText2SQLInput


class FxAgentText2SqlQA(FxAgentChain[FxAgentText2SQLInput, str]):
    def __init__(
        self,
        *,
        output_parser: Optional[
            Callable[
                [FxAgentRunnerConfig, FxAgentText2SQLInput, str], FxAgentParseOutput
            ]
        ] = None,
    ):
        super().__init__(
            "AgentText2SqlQA",
            "An LLM agent for context-based question answering integrates capabilities from a retriever agent to automatically gather relevant contextual information and a text2SQL agent to transform user queries into SQL commands, ensuring precise and efficient data retrieval.",
            agents=[
                FxAgentText2SQL(output_parser=self._parse_text2sql_output),
                FxAgentRetriever(output_parser=self._parse_retriever_output),
                FxAgentContextQA(),
            ],
            output_parser=output_parser,
        )

    def construct_input(self, input: Any) -> FxAgentText2SQLInput:
        if isinstance(input, str):
            return FxAgentText2SQLInput(
                input=input,
            )
        elif isinstance(input, FxAgentText2SQLInput):
            return input
        else:
            raise TypeError(
                f"input type not match, {type(input)} -> {FxAgentText2SQLInput}"
            )

    def _parse_text2sql_output(
        self,
        config: FxAgentRunnerConfig,
        input: FxAgentText2SQLInput,
        agent_response: str,
    ) -> FxAgentRetrieverInput:
        result = FxAgentRetrieverInput(
            input=agent_response,
            addition={
                "original_input": input.input,
            },
        )
        return result

    def _parse_retriever_output(
        self,
        config: FxAgentRunnerConfig,
        input: FxAgentRetrieverInput,
        agent_response: FxAgentRetrieverOutput,
    ) -> FxAgentContextQAInput:
        if len(agent_response.documents) == 0:
            knowledge_context = "No search record."
        else:
            knowledge_context = "\n".join(agent_response.documents)
        context = f"SQL: {agent_response.sql}\n---\n{knowledge_context}\n"

        return FxAgentContextQAInput(
            input=cast(dict, input.addition)["original_input"],
            context=context,
            addition=input.addition,
        )
