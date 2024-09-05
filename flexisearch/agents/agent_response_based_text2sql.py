from flexisearch.agent import FxAgentChain
from flexisearch.agents.agent_text2sql import FxAgentText2SQL
from flexisearch.agents.agent_response_with_context import FxAgentResponseWithContext


class FxAgentResponseBasedText2SQL(FxAgentChain):
    def __init__(self):
        super().__init__(
            "AgentResponseBasedText2SQL",
            "",
            agents=[
                FxAgentText2SQL(),
                FxAgentResponseWithContext(),
            ],
        )
