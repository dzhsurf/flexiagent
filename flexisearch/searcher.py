from abc import ABC, abstractmethod
from typing import Any, Dict, Generic, List, Optional, TypeVar, Union

import sqlparse

from flexisearch.indexer import FxIndexer
from flexisearch.llm import LLM
from flexisearch.model.data import StructuredInput
from flexisearch.prompts import (
    PROMPT_TEMPLATE_RESPONSE_WITH_KNOWLEDGE_CONTEXT,
    PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT)

# TODO: remove langchain deps, use openai api instead


Input = TypeVar("Input", contravariant=True)
Output = TypeVar("Output", covariant=True)


class FxAgent(Generic[Input, Output], ABC):
    description: str

    def __init__(self, description: str):
        super().__init__()
        self.description = description

    @abstractmethod
    def process(self, data: Input) -> Output:
        pass


class FxSearcher:
    llm: LLM
    indexer: FxIndexer
    agents: Dict[str, FxAgent]

    def __init__(self, indexer: FxIndexer):
        self.llm = LLM()
        self.indexer = indexer
        self.agents = {}

    def register(self, agent: FxAgent):
        self.agents[agent.description] = agent

    def assist(self, query: str) -> str:
        # step 1: query understand, identity prompt_template
        # structured_input = self._query_understanding(query)
        # print(structured_input)

        # step 2: text2sql, retrieval context data
        # if structured_input.prompt_template_name == "text2sql":
        sql_query = self._text2sql(query, self.indexer)
        print("SQLQuery:", sql_query)
        documents = self.indexer.retrieval_documents(sql_query)
        print("Retrieval:", documents)
        if len(documents) == 0:
            knowledge_context = "No search record."
        else:
            knowledge_context = "\n".join(documents)
        knowledge_context = f"SQL: {sql_query}\n---\n{knowledge_context}\n"
        # else:
        # knowledge_context = ""

        # step 3: construct response
        return self._response_with_knowledge(query, knowledge_context)

    # def _query_understanding(self, text: str) -> StructuredInput:
    #     # case 1: not applicable.
    #     # searcher.assist(
    #     #   "can you help me do the math problem: x, y, z."
    #     # )
    #     # query understable
    #     # accept intention , not accept ....
    #     # (## .... example, description: metadata, purpose, ), {QA}

    #     # tool chain
    #     # searcher.register(tool, description)

    #     # searcher.match_intention
    #     #  prompt
    #     #   you have tools:
    #     # 1: SQL2Text parser, this tool is good for matching query query to express it in sql format,
    #     # 2: Embedding required, ....
    #     # 3: # f,dl.af
    #     # not application.

    #     # TODO: ???
    #     structured_llm = self.llm.with_structured_output(StructuredInput)

    #     prompt_templates = {
    #         "query": text,
    #         "prompt_templates": {
    #             "text2sql": "translates human-readable text queries into SQL queries, enabling users to interact with databases without needing to know SQL syntax.",
    #             "ner": "name entities recognize",
    #         },
    #     }

    #     prompt_value = StringPromptValue(text=str(prompt_templates))
    #     response = structured_llm.invoke(prompt_value)
    #     return response

    def _text2sql(self, query: str, indexer: FxIndexer) -> str:
        response = self.llm.query(
            PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT,
            variables={
                "input": query,
                "table_info": indexer.get_all_schemas_as_text(),
                "top_k": 5,
            },
        )

        return self._structured_output_sql(response)

    def _structured_output_sql(self, input: str) -> str:
        ### structured sql output
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

    def _response_with_knowledge(self, query: str, knowledge_context: str) -> str:
        response = self.llm.query(
            PROMPT_TEMPLATE_RESPONSE_WITH_KNOWLEDGE_CONTEXT,
            variables={
                "input": query,
                "knowledge_context": knowledge_context,
            },
        )

        return response
