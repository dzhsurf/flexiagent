from typing import Callable, Optional

from flexisearch.agent import (FxAgent, FxAgentInput, FxAgentParseOutput,
                               FxAgentRunnerConfig, FxAgentRunnerResult)


class FxAgentOutputParser(FxAgent[FxAgentInput, FxAgentInput]):
    def __init__(
        self,
        *,
        output_parser: Optional[
            Callable[
                [FxAgentRunnerConfig, FxAgentInput, FxAgentInput], FxAgentParseOutput
            ]
        ] = None,
    ):
        super().__init__(
            "AgentOutputParser",
            "An LLM agent for parse output to another agent's input.",
            output_parser=output_parser,
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentInput,
    ) -> FxAgentRunnerResult[FxAgentInput]:
        return FxAgentRunnerResult(stop=False, value=input)
