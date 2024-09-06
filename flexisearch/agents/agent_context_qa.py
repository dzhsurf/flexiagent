from flexisearch.agent import (
    FxAgent,
    FxAgentInput,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
)
from flexisearch.prompts import PROMPT_TEMPLATE_CONTEXT_QA


class FxAgentContextQAInput(FxAgentInput):
    input: str
    context: str


class FxAgentContextQA(FxAgent[FxAgentContextQAInput, str]):
    def __init__(self):
        super().__init__(
            "AgentContextQA",
            "An LLM agent for context-based question answering (QA) interprets user inquiries in relation to a specific context or document, delivering accurate and relevant answers by leveraging its understanding of the provided information.",
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentContextQAInput,
    ) -> FxAgentRunnerResult[str]:
        response = configure.llm.query(
            PROMPT_TEMPLATE_CONTEXT_QA,
            variables={
                "input": input.input,
                "context": input.context,
            },
        )

        return FxAgentRunnerResult[str](
            stop=False,
            value=response,
        )
