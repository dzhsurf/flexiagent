from typing import Any, Dict

from openai import OpenAI

from flexisearch.prompt import PromptTemplate, PromptValue


class HistoryTracker:
    def __init__(self):
        pass

    def push_message(self, item: Dict[str, Any]):
        pass


# TODO: Structred Output


class LLM:
    def __init__(self):
        self.client = OpenAI()
        self.model = "gpt-4o-mini"
        self.history_tracker = HistoryTracker()

    def query(
        self,
        prompt: PromptTemplate,
        *,
        variables: Dict[str, PromptValue] = {},
    ) -> str:
        response = self.client.chat.completions.create(
            temperature=0,
            model=self.model,
            messages=prompt.to_messages(variables),
            stop=prompt.stop_prompt,
        )

        self.history_tracker.push_message(
            {
                "prompt": prompt,
                "variables": variables,
                "response": response,
            }
        )

        if len(response.choices) > 0 and response.choices[0].message.content:
            return response.choices[0].message.content.strip()

        return ""
