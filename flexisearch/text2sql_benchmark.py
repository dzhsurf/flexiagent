import os
import time
from typing import List, Tuple

import sqlparse
from langchain.chains.sql_database.query import create_sql_query_chain
from langchain.prompts import PromptTemplate
from langchain_community.utilities import SQLDatabase
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)


def read_qa_list() -> List[Tuple[str, str]]:
    qa_list: List[Tuple[str, str]] = []
    temp_item: List[str] = []

    with open("../dev.sql", "r", encoding="utf-8") as f:
        line = f.readline()
        while line:
            line = line.strip()
            if len(line) > 0:
                temp_item.append(line)
                if len(temp_item) == 2:
                    parts = temp_item[0].split(" ||| ")
                    question_part = parts[0]
                    question_split = question_part.split(":")
                    question = (
                        question_split[1].strip() if len(question_split) > 1 else ""
                    )
                    additional_info = parts[1] if len(parts) > 1 else ""
                    additional_info = additional_info.strip()
                    ans = temp_item[1][len("SQL:  ") :]
                    qa_list.append((question + "|||" + additional_info, ans))
                    temp_item = []
            line = f.readline()

    return qa_list


def dump_list_to_file(datalist: List[Tuple[str, str]], filename: str):
    with open(filename, "w", encoding="utf-8") as f:
        for line in datalist:
            f.write(line[0] + "\t" + line[1] + "\n")


template = """first create a syntactically correct {dialect} query to run, then look at the results of the query and return the answer.
Use the following format:

Question: "Question here"
SQLQuery: "SQL Query to run"
SQLResult: "Result of the SQLQuery"
Answer: "Final answer here"

Here are some rules to follow:
- Output in SQL format, not MARKDOWN or JSON.
- Avoid using nested queries in the WHERE clause.
- Prefer using JOINs instead of nested queries.
- Only use the following tables:

{table_info}.

Question: {input}"""
prompt = PromptTemplate.from_template(template)
prompt.input_variables = ["input", "top_k", "table_info", "dialect"]


def main():
    print("Prepare qa list...")
    qa_list = read_qa_list()
    print("QA list total:", len(qa_list))

    # print("Dump gold_result.txt...")
    # dump_list_to_file(
    #     [(qa[1], qa[0].split("|||")[1]) for qa in qa_list], "gold_result.txt"
    # )
    # print("Dump gold_result.txt finish.")

    print("Start evaluate text2sql...")
    pred_sql_list: List[Tuple[str, str]] = []
    for idx, qa in enumerate(qa_list):
        # if idx <= 6:
        #     continue
        question = qa[0]
        parts = question.split("|||")
        query = parts[0]
        db_name = parts[1]
        db_path = f"../database/{db_name}/{db_name}.sqlite"
        db_path = os.path.abspath(db_path)
        db = SQLDatabase.from_uri(f"sqlite:///{db_path}")
        # print(db.run_no_throw("pragma table_info(players);"))
        # print(db.run("pragma table_info(rankings);"))
        # print(db.run("SELECT rankings.ranking_date, rankings.ranking, rankings.player_id, rankings.ranking_points, rankings.tours FROM rankings LIMIT 3;"))
        # print(db.get_table_info(["rankings"]))

        chain = create_sql_query_chain(llm=llm, db=db, prompt=prompt, k=1)
        # chain = create_sql_query_chain(llm=llm, db=db, k=1)
        response = chain.invoke({"question": query})
        print("query:", query)
        print("db_path", db_path)
        print("response", response)

        ### structured sql output
        final_sql = response
        if final_sql.find("SQLQuery:") >= 0:
            final_sql = final_sql[len("SQLQuery:") :]
        if final_sql.find("```sql") >= 0:
            final_sql = final_sql[len("```sql") + 1 : -3]

        final_sql = sqlparse.format(
            final_sql, reindent=True, keyword_case="upper", strip_comments=True
        )
        final_sql = " ".join(final_sql.split())
        if final_sql[0] == '"' and final_sql[-1] == '"':
            final_sql = final_sql[1:-1]
        pred_sql_list.append((final_sql, db_name))
        print(idx, query, final_sql)
        time.sleep(1)
        # db_result = db.run(final_sql)
        # print(db_result)
        # ans = qa[1]
        # db_result2 = db.run(ans)
        # print(idx, query)
        # print(ans)
        # print(sql_query)
        # print(db_result1, db_result2)
        # break
    print("Finish execute text2sql.")

    print("Dump pred_result.txt...")
    dump_list_to_file(pred_sql_list, "pred_result.txt")
    print("Dump pred_result.txt finish.")


if __name__ == "__main__":
    main()
