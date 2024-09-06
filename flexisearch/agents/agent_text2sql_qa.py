from typing import Callable, Optional, TypeVar, cast

from flexisearch.agent import FxAgentChain, FxAgentRunnerConfig
from flexisearch.agents.agent_context_qa import (FxAgentContextQA,
                                                 FxAgentContextQAInput)
from flexisearch.agents.agent_retriever import (FxAgentRetriever,
                                                FxAgentRetrieverInput,
                                                FxAgentRetrieverOutput)
from flexisearch.agents.agent_text2sql import (FxAgentText2SQL,
                                               FxAgentText2SQLInput)
from flexisearch.agents.types import TypeDict

ParseOutput = TypeVar("ParseOutput", covariant=True)


class FxAgentText2SqlQA(FxAgentChain[FxAgentText2SQLInput, str]):
    def __init__(
        self,
        *,
        output_parser: Optional[
            Callable[[FxAgentRunnerConfig, FxAgentText2SQLInput, str], ParseOutput]
        ] = None,
    ):
        super().__init__(
            "AgentText2SqlQA",
            "",
            agents=[
                FxAgentText2SQL(output_parser=self._parse_text2sql_output),
                FxAgentRetriever(output_parser=self._parse_retriever_output),
                FxAgentContextQA(),
            ],
            output_parser=output_parser,
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
