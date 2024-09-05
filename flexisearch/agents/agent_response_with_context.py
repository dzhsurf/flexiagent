from flexisearch.agent import FxAgent

from flexisearch.agent import (
    FxAgent,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
    FxAgentRunnerValue,
)
from flexisearch.prompts import PROMPT_TEMPLATE_RESPONSE_WITH_KNOWLEDGE_CONTEXT


class FxAgentResponseWithContext(FxAgent):
    def __init__(self):
        super().__init__("AgentResponseWithContext", "")

    def invoke(
        self, configure: FxAgentRunnerConfig, input: FxAgentRunnerValue
    ) -> FxAgentRunnerResult:
        query = ""
        knowledge_context = ""

        if isinstance(input, str):
            query = input
        elif isinstance(input, dict):
            query = str(input["input"])
            if "context" in input:
                knowledge_context = input["knowledge_context"]
        else:
            raise ValueError("input type not correct")

        response = configure.llm.query(
            PROMPT_TEMPLATE_RESPONSE_WITH_KNOWLEDGE_CONTEXT,
            variables={
                "input": query,
                "knowledge_context": knowledge_context,
            },
        )

        return FxAgentRunnerResult(
            stop=False,
            error_msg="",
            value=response,
        )
