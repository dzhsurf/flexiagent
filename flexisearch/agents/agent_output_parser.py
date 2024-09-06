from typing import Callable, Optional, TypeVar

from flexisearch.agent import (FxAgent, FxAgentInput, FxAgentRunnerConfig,
                               FxAgentRunnerResult)

ParseOutput = TypeVar("ParseOutput", covariant=True, bound=FxAgentInput)
T = TypeVar("T", bound=FxAgentInput)


class FxAgentOutputParser(FxAgent[T, T]):
    def __init__(
        self,
        *,
        output_parser: Optional[
            Callable[[FxAgentRunnerConfig, T, T], ParseOutput]
        ] = None,
    ):
        super().__init__(
            "AgentOutputParser",
            "",
            output_parser=output_parser,
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: T,
    ) -> FxAgentRunnerResult[T]:
        return FxAgentRunnerResult(stop=False, value=input)
