import os
import time
from typing import List, Tuple

from flexisearch.agent import FxAgentRunnerConfig
from flexisearch.agents.agent_text2sql import FxAgentText2SQL, FxAgentText2SQLInput
from flexisearch.database.db_executor import DBConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm import LLM


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


def main():
    print("Prepare qa list...")
    qa_list = read_qa_list()
    print("QA list total:", len(qa_list))

    print("Start evaluate text2sql...")
    llm = LLM()
    agent = FxAgentText2SQL()
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
        db_uri = f"sqlite:///{db_path}"

        indexer = FxIndexer()
        indexer.connect_to_metadb(DBConfig(name=db_name, db_uri=db_uri))
        result = agent.invoke(
            configure=FxAgentRunnerConfig(llm, indexer),
            input=FxAgentText2SQLInput(input=query),
        )

        print("query:", query, "db:", db_name, db_path)
        print(idx, query, result.value)
        pred_sql_list.append((result.value, db_name))
        time.sleep(1)
    print("Finish execute text2sql.")

    print("Dump pred_result.txt...")
    dump_list_to_file(pred_sql_list, "pred_result.txt")
    print("Dump pred_result.txt finish.")


if __name__ == "__main__":
    main()
