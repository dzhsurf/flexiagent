import json
import logging
from typing import Any, Dict, List

from flexisearch.agent import (
    FxAgent,
    FxAgentInput,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
)
from flexisearch.prompts import PROMPT_TEMPLATE_INTENT_RECOGNITION

logger = logging.getLogger(__name__)


class FxAgentIntentRecognizerInput(FxAgentInput):
    input: str
    agents: List[FxAgent[FxAgentInput, Any]]


class FxAgentIntentRecognizer(
    FxAgent[FxAgentIntentRecognizerInput, List[FxAgent[FxAgentInput, Any]]]
):
    def __init__(self):
        super().__init__(
            "AgentIntentRecognition",
            "Can be used to pickup the option that best matches the user's question intention based on the option's description.",
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentIntentRecognizerInput,
    ) -> FxAgentRunnerResult[List[FxAgent[FxAgentInput, Any]]]:
        agent_dict: Dict[str, FxAgent[FxAgentInput, Any]] = {}

        options: List[str] = []
        description = ""
        for agent in input.agents:
            options.append(f'"{agent.name}"')
            description += f"* {agent.name}: {agent.description}\n"
            agent_dict[agent.name] = agent
        options_text = ",".join(options)

        response = configure.llm.query(
            PROMPT_TEMPLATE_INTENT_RECOGNITION,
            variables={
                "input": input.input,
                "options": f"[{options_text}]",
                "description": description,
            },
        )

        # format result to json
        logger.info("\n====LLM Response====\n%s", response)
        p = response.find("JSONResult:")
        if p >= 0:
            response = response[p + len("JSONResult:") :].strip()

        result: List[FxAgent[FxAgentInput, Any]] = []
        try:
            json_obj = json.loads(response)
            if isinstance(json_obj, list) and len(json_obj) > 0:
                for item in json_obj:
                    agent_name = str(item)
                    if agent_name in agent_dict:
                        result.append(agent_dict[agent_name])
        except Exception:
            pass

        logger.info("Matches: %s", [item.name for item in result])

        return FxAgentRunnerResult[List[FxAgent[FxAgentInput, Any]]](
            stop=False,
            value=result,
        )
