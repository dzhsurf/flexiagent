from typing import Callable, List, Optional, TypeVar

from flexisearch.agent import (FxAgent, FxAgentInput, FxAgentOutput,
                               FxAgentParseOutput, FxAgentRunnerConfig,
                               FxAgentRunnerResult)


class FxAgentRetrieverInput(FxAgentInput):
    input: str


class FxAgentRetrieverOutput(FxAgentOutput):
    sql: str
    documents: List[str]


class FxAgentRetriever(FxAgent[FxAgentRetrieverInput, FxAgentRetrieverOutput]):
    def __init__(
        self,
        *,
        output_parser: Optional[
            Callable[
                [FxAgentRunnerConfig, FxAgentRetrieverInput, FxAgentRetrieverOutput],
                FxAgentParseOutput,
            ]
        ] = None,
    ):
        super().__init__(
            "AgentRetriever",
            "An LLM agent for retrieve documents by the input SQL.",
            output_parser=output_parser,
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentRetrieverInput,
    ) -> FxAgentRunnerResult[FxAgentRetrieverOutput]:
        documents = configure.indexer.retrieve_documents(input.input)

        return FxAgentRunnerResult[FxAgentRetrieverOutput](
            stop=False,
            value=FxAgentRetrieverOutput(
                sql=input.input,
                documents=documents,
            ),
        )
