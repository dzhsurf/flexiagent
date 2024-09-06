from typing import Callable, Optional, TypeVar

import sqlparse

from flexisearch.agent import (FxAgent, FxAgentInput, FxAgentRunnerConfig,
                               FxAgentRunnerResult)
from flexisearch.prompts import PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT

ParseOutput = TypeVar("ParseOutput", covariant=True)


class FxAgentText2SQLInput(FxAgentInput):
    input: str
    table_info: Optional[str] = None
    top_k: Optional[int] = None


class FxAgentText2SQL(FxAgent[FxAgentText2SQLInput, str]):
    def __init__(
        self,
        *,
        output_parser: Optional[
            Callable[[FxAgentRunnerConfig, FxAgentText2SQLInput, str], ParseOutput]
        ] = None,
    ):
        super().__init__(
            "AgentText2SQL",
            "",
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
        if sql.find("SQLQuery:") >= 0:
            sql = sql[len("SQLQuery:") :]
        if sql.find("```sql") >= 0:
            sql = sql[len("```sql") + 1 : -3]

        sql = sqlparse.format(
            sql, reindent=True, keyword_case="upper", strip_comments=True
        )
        sql = " ".join(sql.split())
        if sql[0] == '"' and sql[-1] == '"':
            sql = sql[1:-1]

        return sql
