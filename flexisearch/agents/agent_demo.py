from flexisearch.agent import (
    FxAgent,
    FxAgentInput,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
)

# from flexisearch.prompts import PROMPT_TEMPLATE...


class FxAgentDemoInput(FxAgentInput):
    input: str


class FxAgentExtractText(FxAgent[FxAgentDemoInput, str]):
    def __init__(self):
        super().__init__(
            "AgentDemo",
            "This is description.",
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentDemoInput,
    ) -> FxAgentRunnerResult[str]:
        # response = configure.llm.query(
        #     PROMPT_TEMPLATE,
        #     variables={
        #         "input": input.input,
        #     },
        # )

        return FxAgentRunnerResult[str](
            stop=False,
            value="",
        )
