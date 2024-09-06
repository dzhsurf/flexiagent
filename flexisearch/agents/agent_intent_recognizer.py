import json
from typing import Any, List

from flexisearch.agent import (FxAgent, FxAgentInput, FxAgentRunnerConfig,
                               FxAgentRunnerResult)
from flexisearch.prompts import PROMPT_TEMPLATE_INTENT_RECOGNITION


class FxAgentIntentRecognizerInput(FxAgentInput):
    input: str
    agents: List[FxAgent[FxAgentInput, Any]]


class FxAgentIntentRecognizer(
    FxAgent[FxAgentIntentRecognizerInput, List[FxAgent[FxAgentInput, Any]]]
):
    def __init__(self):
        super().__init__("AgentIntentRecognition", "")

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentIntentRecognizerInput,
    ) -> FxAgentRunnerResult[List[FxAgent[FxAgentInput, Any]]]:
        agent_dict = {}
        actions = ""
        for agent in input.agents:
            actions += f"* {agent.name}: {agent.description}\n"
            agent_dict[agent.name] = agent

        response = configure.llm.query(
            PROMPT_TEMPLATE_INTENT_RECOGNITION,
            variables={
                "input": input.input,
                "actions": actions,
            },
        )

        print("Intent:", response)
        # format result to json
        if response.startswith("JSONResult:"):
            response = response[len("JSONResult:") + 1 :].strip()
        print("Formated:", response)

        result = []
        try:
            json_obj = json.loads(response)
            if isinstance(json_obj, list) and len(json_obj) > 0:
                for item in json_obj:
                    agent_name = str(item)
                    if agent_name in agent_dict:
                        result.append(agent_dict[agent_name])
        except Exception:
            pass

        return FxAgentRunnerResult[List[FxAgent[FxAgentInput, Any]]](
            stop=False,
            value=result,
        )
