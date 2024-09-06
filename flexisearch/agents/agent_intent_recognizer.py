from typing import Any, List

from flexisearch.agent import (
    FxAgent,
    FxAgentInput,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
)


class FxAgentIntentRecognizerInput(FxAgentInput):
    input: str
    agents: List[FxAgent[Any, Any]]


class FxAgentIntentRecognizer(
    FxAgent[FxAgentIntentRecognizerInput, List[FxAgent[Any, Any]]]
):
    def __init__(self):
        super().__init__("AgentIntentRecognition", "")

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentIntentRecognizerInput,
    ) -> FxAgentRunnerResult[List[FxAgent[Any, Any]]]:
        # query = ""
        # knowledge_context = ""

        # if isinstance(input, str):
        #     query = input
        # elif isinstance(input, dict):
        #     query = str(input["input"])
        #     if "context" in input:
        #         knowledge_context = input["knowledge_context"]
        # else:
        #     raise ValueError("input type not correct")

        # response = configure.llm.query(
        #     PROMPT_TEMPLATE_CONTEXT_QA,
        #     variables={
        #         "input": query,
        #         "knowledge_context": knowledge_context,
        #     },
        # )

        return FxAgentRunnerResult[List[FxAgent[Any, Any]]](
            stop=False,
            value=[],
        )
