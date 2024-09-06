from dataclasses import dataclass
from typing import Any, Callable, Dict, Generic, List, Optional, Protocol, TypeVar

from pydantic import BaseModel

from flexisearch.indexer import FxIndexer
from flexisearch.llm import LLM


class FxAgentVariable(BaseModel):
    pass


class FxAgentInput(FxAgentVariable):
    addition: Optional[Dict[str, Any]] = None


class FxAgentOutput(FxAgentVariable):
    pass


Input = TypeVar("Input", contravariant=True, bound=FxAgentInput)
Output = TypeVar("Output", covariant=True)
ParseOutput = TypeVar("ParseOutput", covariant=True, bound=FxAgentInput)


@dataclass
class FxAgentRunnerConfig:
    llm: LLM
    indexer: FxIndexer


@dataclass
class FxAgentRunnerResult(Generic[Output]):
    stop: bool
    value: Output


class FxAgentRunner(Generic[Input, Output], Protocol):
    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: Input,
    ) -> FxAgentRunnerResult[Output]:
        pass


class FxAgent(Generic[Input, Output], FxAgentRunner[Input, Output]):
    def __init__(
        self,
        name: str,
        description: str,
        *,
        output_parser: Optional[
            Callable[[FxAgentRunnerConfig, Input, Output], ParseOutput]
        ] = None,
    ):
        super().__init__()
        self.name = name
        self.description = description
        self.output_parser = output_parser


class FxAgentChain(Generic[Input, Output], FxAgent[Input, Output]):
    def __init__(
        self,
        name: str,
        description: str,
        *,
        agents: List[FxAgent[Any, Any]],
        output_parser: Optional[
            Callable[[FxAgentRunnerConfig, Input, Output], ParseOutput]
        ] = None,
    ) -> None:
        super().__init__(name, description, output_parser=output_parser)
        self.agents = agents

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: Input,
    ) -> FxAgentRunnerResult[Output]:
        # Convert first input to RunnerResult
        pre_result = FxAgentRunnerResult[Any](
            stop=False,
            value=input,
        )

        # invoke chain
        for agent in self.agents:
            # invoke agent
            result = agent.invoke(configure, pre_result.value)
            # use output parser to convert output result
            if agent.output_parser:
                result.value = agent.output_parser(configure, input, result.value)

            if result.stop:
                # TODO: type check
                return result

            pre_result = result

        # TODO: type check
        # if not isinstance(pre_result.value, Output):
        #     raise TypeError(f"Output type not match. {type(pre_result.value)} -> {Output}")

        return FxAgentRunnerResult[Output](
            stop=pre_result.stop,
            value=pre_result.value,
        )
