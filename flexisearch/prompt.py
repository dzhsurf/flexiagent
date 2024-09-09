import re
from dataclasses import dataclass
from typing import Dict, Iterable, List, Set, Union

from openai.types.chat import (
    ChatCompletionAssistantMessageParam,
    ChatCompletionMessageParam,
    ChatCompletionSystemMessageParam,
    ChatCompletionUserMessageParam,
)
from pydantic import BaseModel

PromptValue = Union[str, int]


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
    prompt: str
    user_question_prompt: str
    stop_prompt: str
    vaild_variables: Set[str]
    fewshot_samples: List[PromptFewshotSample]

    def __init__(
        self,
        prompt: str,
        stop_prompt: str = "",
        user_question_prompt: str = "Question: {input}",
    ):
        self.prompt = prompt
        self.user_question_prompt = user_question_prompt
        self.stop_prompt = stop_prompt
        self.vaild_variables = set()
        self.fewshot_samples = []
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
            self.vaild_variables.add(variable)
        variables = re.findall(extract_variable_pattern, self.user_question_prompt)

        for variable in variables:
            self.vaild_variables.add(variable)

    def _replace_text_by_variables(
        self, text: str, variables: Dict[str, PromptValue]
    ) -> str:
        for key, value in variables.items():
            if key not in self.vaild_variables:
                continue
            text = text.replace("{" + key + "}", str(value))
        return text
