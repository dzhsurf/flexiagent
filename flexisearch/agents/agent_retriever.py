from typing import Callable, List, Optional, TypeVar

from flexisearch.agent import (FxAgent, FxAgentInput, FxAgentOutput,
                               FxAgentRunnerConfig, FxAgentRunnerResult)
from flexisearch.agents.types import TypeDict

ParseOutput = TypeVar("ParseOutput", covariant=True)


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
                ParseOutput,
            ]
        ] = None,
    ):
        super().__init__("AgentRetriever", "", output_parser=output_parser)

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
