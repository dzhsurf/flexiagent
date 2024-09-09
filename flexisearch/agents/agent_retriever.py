import logging
from typing import Callable, List, Optional, TypeVar

from flexisearch.agent import (
    FxAgent,
    FxAgentInput,
    FxAgentOutput,
    FxAgentParseOutput,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
)

logger = logging.getLogger(__name__)


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
            "Can retrieve results from the database based on the input SQL.",
            output_parser=output_parser,
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentRetrieverInput,
    ) -> FxAgentRunnerResult[FxAgentRetrieverOutput]:
        try:
            documents = configure.indexer.retrieve_documents(input.input)
        except Exception as e:
            logger.error(e)
            documents = []

        msg = "\n".join(documents)
        logger.info(f"\n====Data====\n{msg}")

        return FxAgentRunnerResult[FxAgentRetrieverOutput](
            stop=False,
            value=FxAgentRetrieverOutput(
                sql=input.input,
                documents=documents,
            ),
        )
