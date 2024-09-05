import sqlparse

from flexisearch.agent import (
    FxAgent,
    FxAgentRunnerConfig,
    FxAgentRunnerResult,
    FxAgentRunnerValue,
)

from flexisearch.prompts import PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT


class FxAgentText2SQL(FxAgent):
    def __init__(self):
        super().__init__("AgentText2SQL", "")

    def invoke(
        self, configure: FxAgentRunnerConfig, input: FxAgentRunnerValue
    ) -> FxAgentRunnerResult:
        query = ""
        table_info = ""
        top_k = 5

        if isinstance(input, str):
            query = input
            table_info = configure.indexer.get_all_schemas_as_text()
        elif isinstance(input, dict):
            query = str(input["input"])
            if "table_info" in input:
                table_info = input["table_info"]
            else:
                table_info = configure.indexer.get_all_schemas_as_text()
            if "top_k" in input:
                top_k = int(input["top_k"])
        else:
            raise ValueError("input type not correct")

        # llm query
        response = configure.llm.query(
            PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT,
            variables={
                "input": query,
                "table_info": table_info,
                "top_k": top_k,
            },
        )

        final_sql = self._structured_output_sql(response)
        return FxAgentRunnerResult(
            stop=False,
            error_msg="",
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
