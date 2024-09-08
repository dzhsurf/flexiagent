from typing import Callable, Optional

import sqlparse

from flexisearch.agent import (
    FxAgent,
    FxAgentInput,
    FxAgentParseOutput,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
)
from flexisearch.prompts import PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT


class FxAgentText2SQLInput(FxAgentInput):
    input: str
    table_info: Optional[str] = None
    top_k: Optional[int] = None


class FxAgentText2SQL(FxAgent[FxAgentText2SQLInput, str]):
    def __init__(
        self,
        *,
        output_parser: Optional[
            Callable[
                [FxAgentRunnerConfig, FxAgentText2SQLInput, str], FxAgentParseOutput
            ]
        ] = None,
    ):
        super().__init__(
            "AgentText2SQL",
            "An LLM agent for translates natural language queries into structured SQL queries",
            output_parser=output_parser,
        )

    def invoke(
        self,
        configure: FxAgentRunnerConfig,
        input: FxAgentText2SQLInput,
    ) -> FxAgentRunnerResult[str]:
        if input.table_info is None:
            input.table_info = configure.indexer.get_all_schemas_as_text()
        if input.top_k is None:
            input.top_k = 5

        # llm query
        response = configure.llm.query(
            PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT,
            variables={
                "input": input.input,
                "table_info": input.table_info,
                "top_k": input.top_k,
            },
        )

        final_sql = self._structured_output_sql(response)
        return FxAgentRunnerResult[str](
            stop=False,
            value=final_sql,
        )

    def _structured_output_sql(self, input: str) -> str:
        ### TODO: structured sql output, SQLChcker
        sql = input
        content_tags = [("SQLQuery:", None), ("```sql", "```")]
        for content_tag in content_tags:
            p1 = sql.find(content_tag[0])
            if content_tag[1]:
                p2 = sql.find(content_tag[0], p1 + len(content_tag[0]))
                sql = sql[p1 + len(content_tag[0]) : p2]
            else:
                sql = sql[p1 + len(content_tag[0]) :]

        sql = sqlparse.format(
            sql, reindent=True, keyword_case="upper", strip_comments=True
        )
        sql = " ".join(sql.split())
        if sql[0] == '"' and sql[-1] == '"':
            sql = sql[1:-1]

        return sql.strip()
