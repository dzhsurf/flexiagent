import re
from dataclasses import dataclass
from typing import Any, Dict, Iterable, List, Set, Union

from openai.types.chat import (
    ChatCompletionAssistantMessageParam,
    ChatCompletionMessageParam,
    ChatCompletionSystemMessageParam,
    ChatCompletionUserMessageParam,
)
from pydantic import BaseModel

PromptValue = Any


@dataclass
class PromptFewshotSample:
    user: str
    assistant: str


class PromptInstTemplate(BaseModel):
    inst_tag_begin: str = "[INST]"
    inst_tag_end: str = "[/INST]"
    sys_tag_begin: str = "<<SYS>>"
    sys_tag_end: str = "<</SYS>>"


class PromptTemplate:
    def __init__(
        self,
        prompt: str,
        stop_prompt: str = "",
        user_question_prompt: str = "Question: {input}",
    ):
        self.prompt: str = prompt
        self.user_question_prompt: str = user_question_prompt
        self.stop_prompt: str = stop_prompt
        self.template_variables: Set[str] = set()
        self.fewshot_samples: List[PromptFewshotSample] = []
        self._build_template()

    def add_fetshot_samples(self, samples: List[PromptFewshotSample]):
        self.fewshot_samples += samples

    def to_text(
        self, inst_template: PromptInstTemplate, variables: Dict[str, PromptValue] = {}
    ) -> str:
        system_message = self._replace_text_by_variables(self.prompt, variables)
        user_question_message = self._replace_text_by_variables(
            self.user_question_prompt, variables
        )
        return f"{inst_template.inst_tag_begin}{inst_template.sys_tag_begin}{system_message}{inst_template.sys_tag_end}\n{user_question_message}{inst_template.inst_tag_end}"

    def to_openai_chat_completion_messages(
        self,
        variables: Dict[str, PromptValue] = {},
    ) -> Iterable[ChatCompletionMessageParam]:
        result: List[ChatCompletionMessageParam] = []

        # system message
        system_message = self._replace_text_by_variables(self.prompt, variables)
        result.append(
            ChatCompletionSystemMessageParam(role="system", content=system_message)
        )

        # user and assistant message
        for fewshot_sample in self.fewshot_samples:
            user_content = self._replace_text_by_variables(
                fewshot_sample.user, variables
            )
            result.append(
                ChatCompletionUserMessageParam(role="user", content=user_content)
            )
            assistant_content = self._replace_text_by_variables(
                fewshot_sample.assistant, variables
            )
            result.append(
                ChatCompletionAssistantMessageParam(
                    role="assistant", content=assistant_content
                )
            )

        # user question
        user_question_message = self._replace_text_by_variables(
            self.user_question_prompt, variables
        )
        result.append(
            ChatCompletionUserMessageParam(role="user", content=user_question_message)
        )

        return result

    def _build_template(self):
        extract_variable_pattern = r"\{([^{}\s]+)}"
        variables = re.findall(extract_variable_pattern, self.prompt)

        for variable in variables:
            self.template_variables.add(variable)
        variables = re.findall(extract_variable_pattern, self.user_question_prompt)

        for variable in variables:
            self.template_variables.add(variable)

    def _replace_text_by_variables(
        self, text: str, variables: Dict[str, PromptValue]
    ) -> str:
        for full_key in self.template_variables:
            obj = variables
            keys = full_key.split(".")
            for k in keys:
                if isinstance(obj, dict):
                    obj = obj[k]
                else:
                    obj = getattr(obj, k)
            text = text.replace("{" + full_key + "}", str(obj))
        return text
