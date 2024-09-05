from typing import Any, Dict, List, Optional, Union

from flexisearch.indexer import FxIndexer
from flexisearch.model.data import StructuredInput
from langchain_openai import ChatOpenAI
from langchain.prompts import PromptTemplate

from langchain_core.prompt_values import StringPromptValue
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.messages import HumanMessage

import sqlparse


class FxSearcher:
    def __init__(self, indexer: FxIndexer):
        self.llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
        self.indexer = indexer

    def assist(self, query: str) -> str:
        # step 1: query understand, identity prompt_template
        structured_input = self._query_understanding(query)
        print(structured_input)

        # step 2: text2sql, retrieval context data
        if structured_input.prompt_template_name == "text2sql":
            sql_query = self._text2sql(query, self.indexer)
            print("SQLQuery:", sql_query)
            documents = self.indexer.retrieval_documents(sql_query)
            print("Retrieval:", documents)
            if len(documents) == 0:
                knowledge_context = "No search record."
            else:
                knowledge_context = "\n".join(documents)
            knowledge_context = f"SQL: {sql_query}\n---\n{knowledge_context}\n"
        else:
            knowledge_context = ""

        # step 3: construct response
        return self._response_with_knowledge(query, knowledge_context)

    def _query_understanding(self, text: str) -> StructuredInput:
        # TODO: ???
        structured_llm = self.llm.with_structured_output(StructuredInput)

        prompt_templates = {
            "query": text,
            "prompt_templates": {
                "text2sql": "translates human-readable text queries into SQL queries, enabling users to interact with databases without needing to know SQL syntax.",
                "ner": "name entities recognize",
            },
        }

        prompt_value = StringPromptValue(text=str(prompt_templates))
        response = structured_llm.invoke(prompt_value)
        return response

    def _text2sql(self, query: str, indexer: FxIndexer) -> str:
        template = """You are a SQLite expert. Given an input question, first create a syntactically correct SQLite query to run, then look at the results of the query and return the answer to the input question.
Unless the user specifies in the question a specific number of examples to obtain, query for at most {top_k} results using the LIMIT clause as per SQLite. You can order the results to return the most informative data in the database.
Never query for all columns from a table. You must query only the columns that are needed to answer the question. Wrap each column name in double quotes (") to denote them as delimited identifiers.
Pay attention to use only the column names you can see in the tables below. Be careful to not query for columns that do not exist. Also, pay attention to which column is in which table.
Pay attention to use date('now') function to get the current date, if the question involves "today".

Use the following format:

Question: Question here
SQLQuery: SQL Query to run
SQLResult: Result of the SQLQuery
Answer: Final answer here

Here are some rules to follow:
- Output in SQL format, not MARKDOWN or JSON.
- Avoid using nested queries in the WHERE clause.
- Prefer using JOINs instead of nested queries.
- Only use the following tables:

{table_info}.

Question: {input}"""
        prompt_to_use = PromptTemplate.from_template(template)
        prompt_to_use.input_variables = ["input", "top_k", "table_info"]

        inputs = {
            "input": lambda x: x["question"] + "\nSQLQuery: ",
            "table_info": lambda x: self.indexer.get_all_schemas_as_text(),
        }
        top_k = 5
        chain = (
            RunnablePassthrough.assign(**inputs)  # type: ignore
            | (lambda x: {k: v for k, v in x.items() if k not in ("question")})
            | prompt_to_use.partial(top_k=str(top_k))
            | self.llm.bind(stop=["\nSQLResult:"])
            | StrOutputParser()
        )

        response = chain.invoke({"question": query})

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
        template = """You are a helpful assistant, follow the instructure, response the question below.

The following are results accurately matched from the database based on the user's question. 
Answer the user's question based on these results.
{knowledge_context}

Question: {input}
Answer: """
        prompt_to_use = PromptTemplate.from_template(template)
        prompt_to_use.input_variables = ["input", "knowledge_context"]

        inputs = {
            "input": lambda x: x["question"],
            "knowledge_context": lambda x: x["knowledge_context"],
        }

        chain = (
            RunnablePassthrough.assign(**inputs)  # type: ignore
            | prompt_to_use
            | self.llm.bind(stop=["\nAnswer:"])
            | StrOutputParser()
        )

        response = chain.invoke(
            {
                "question": query,
                "knowledge_context": knowledge_context,
            }
        )
        return str(response)
