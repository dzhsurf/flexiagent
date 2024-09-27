from flexiagent.prompts.prompt import PromptTemplate

PROMPT_TEXT_DEFAULT_USER_QUESTION = "Question: {input}"

PROMPT_TEMPLATE_DEFAULT = PromptTemplate(
    prompt="Your are helpful assistant, follow user's instructure to answser question.\n\n",
    stop_prompt="",
    user_question_prompt=PROMPT_TEXT_DEFAULT_USER_QUESTION,
)

# Unless the user specifies in the question a specific number of examples to obtain, query for at most {top_k} results using the LIMIT clause as per SQLite. You can order the results to return the most informative data in the database.
PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT = PromptTemplate(
    prompt="""You are a SQLite expert. Given an input question, first create a syntactically correct SQLite query to run, then look at the results of the query and return the answer to the input question.
Never query for all columns from a table. You must query only the columns that are needed to answer the question. Wrap each column name in double quotes (") to denote them as delimited identifiers.
Pay attention to use only the column names you can see in the tables below. Be careful to not query for columns that do not exist. Also, pay attention to which column is in which table.
Pay attention to use date('now') function to get the current date, if the question involves "today". 
Output in SQL format, not MARKDOWN or JSON. 
Avoid using nested queries in the WHERE clause. 
Prefer using JOINs instead of nested queries.

Use the following format:

Question: Question here
SQLQuery: SQL Query to run
SQLResult: Result of the SQLQuery
Answer: Final answer here

Only use the following tables:
{table_info}

{addition_desc}
""",
    stop_prompt="SQLResult:",
    user_question_prompt=PROMPT_TEXT_DEFAULT_USER_QUESTION,
)

PROMPT_TEMPLATE_CONTEXT_QA = PromptTemplate(
    prompt="""You are a helpful assistant, follow the instructure, response the question below.

The following are results accurately matched from the database based on the user's question. 
Answer the user's question based on these results.
{context}

""",
    stop_prompt="",
    user_question_prompt=PROMPT_TEXT_DEFAULT_USER_QUESTION,
)

PROMPT_TEMPLATE_INTENT_RECOGNITION = PromptTemplate(
    prompt="""You are a classification expert. Select the option that best matches the user's question from the given JSON options.

You must use the following format:

Question: Question here
JSONResult: ["JSON result here"]
Analyse: Final answer here

---
JSONOptions: {options}
Option description:
{description}
""",
    stop_prompt="Analyse:",
    user_question_prompt="Question: {input}",
)


__all__ = [
    "PromptTemplate",
    "PROMPT_TEMPLATE_DEFAULT",
    "PROMPT_TEMPLATE_SQLITE_TEXT2SQL_EXPERT",
    "PROMPT_TEMPLATE_INTENT_RECOGNITION",
]
