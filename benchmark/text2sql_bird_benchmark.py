# TODO: ...
# official: https://bird-bench.github.io/

# dataset
# dev-set: https://bird-bench.oss-cn-beijing.aliyuncs.com/dev.zip
# train-set: https://bird-bench.oss-cn-beijing.aliyuncs.com/train.zip

# evaluation suite: https://github.com/bird-bench/mini_dev/tree/main
# code copy from bird-bench/mini_dev/llm/src/evaluation_ex.py

import argparse
import os
import sys
import json
import sqlite3
import multiprocessing as mp
from typing import Any, Dict, List, Optional, Tuple, cast
from func_timeout import func_timeout, FunctionTimedOut
from dataclasses import dataclass

from flexisearch.agent import FxAgentRunnerConfig
from flexisearch.agents.agent_text2sql import FxAgentText2SQL, FxAgentText2SQLInput
from flexisearch.database.db_executor import DBConfig
from flexisearch.indexer import FxIndexer
from flexisearch.llm.config import LLMConfig
from flexisearch.llm.llm import LLM
#### utils

exec_result: List[Any] = []


def load_json(dir: str) -> Any:
    with open(dir, "r") as j:
        contents = json.loads(j.read())
    return contents


def connect_db(sql_dialect: str, db_path: str) -> sqlite3.Connection | Any:
    if sql_dialect == "SQLite":
        conn = sqlite3.connect(db_path)
    elif sql_dialect == "MySQL":
        pass
        # conn = connect_mysql()
    elif sql_dialect == "PostgreSQL":
        pass
        # conn = connect_postgresql()
    else:
        raise ValueError("Unsupported SQL dialect")
    return conn


def execute_sql(predicted_sql, ground_truth, db_path, sql_dialect, calculate_func):
    conn = connect_db(sql_dialect, db_path)
    # Connect to the database
    cursor = conn.cursor()
    cursor.execute(predicted_sql)
    predicted_res = cursor.fetchall()
    cursor.execute(ground_truth)
    ground_truth_res = cursor.fetchall()
    conn.close()
    res = calculate_func(predicted_res, ground_truth_res)
    return res


def package_sqls(sql_path: str, db_root_path: str) -> Tuple[Any, Any]:
    clean_sqls = []
    db_path_list = []

    with open(sql_path, "r", encoding="utf-8") as fp:
        line = fp.readline()
        while line:
            line = line.strip()
            sql, db_name = line.split("\t")
            clean_sqls.append(sql)
            db_path_list.append(
                db_root_path + "/" + db_name + "/" + db_name + ".sqlite"
            )

            line = fp.readline()

    return clean_sqls, db_path_list


def sort_results(list_of_dicts):
    return sorted(list_of_dicts, key=lambda x: x["sql_idx"])


def print_data(score_lists, count_lists, metric="F1 Score"):
    levels = ["simple", "moderate", "challenging", "total"]
    print("{:20} {:20} {:20} {:20} {:20}".format("", *levels))
    print("{:20} {:<20} {:<20} {:<20} {:<20}".format("count", *count_lists))

    print(
        f"======================================    {metric}    ====================================="
    )
    print("{:20} {:<20.2f} {:<20.2f} {:<20.2f} {:<20.2f}".format(metric, *score_lists))


####


#### main


def result_callback(result):
    global exec_result
    exec_result.append(result)
    print(result)


def calculate_ex(predicted_res, ground_truth_res):
    res = 0
    if set(predicted_res) == set(ground_truth_res):
        res = 1
    return res


def execute_model(
    predicted_sql, ground_truth, db_place, idx, meta_time_out, sql_dialect
) -> Dict[str, Any]:
    try:
        res = func_timeout(
            meta_time_out,
            execute_sql,
            args=(predicted_sql, ground_truth, db_place, sql_dialect, calculate_ex),
        )
    except KeyboardInterrupt:
        sys.exit(0)
    except FunctionTimedOut:
        # result = [(f"timeout",)]
        res = 0
    except Exception:
        # result = [(f"error",)]  # possibly len(query) > 512 or not executable
        res = 0
    result = {"sql_idx": idx, "res": res}
    return result


def run_sqls_parallel(
    sqls, db_places, num_cpus=1, meta_time_out=30.0, sql_dialect="SQLite"
):
    pool = mp.Pool(processes=num_cpus)
    for i, sql_pair in enumerate(sqls):
        predicted_sql, ground_truth = sql_pair
        pool.apply_async(
            execute_model,
            args=(
                predicted_sql,
                ground_truth,
                db_places[i],
                i,
                meta_time_out,
                sql_dialect,
            ),
            callback=result_callback,
        )
    pool.close()
    pool.join()


def compute_acc_by_diff(exec_results, diff_json_path):
    num_queries = len(exec_results)
    results = [res["res"] for res in exec_results]
    contents = load_json(diff_json_path)
    simple_results, moderate_results, challenging_results = [], [], []

    for i, content in enumerate(contents):
        if content["difficulty"] == "simple":
            simple_results.append(exec_results[i])

        if content["difficulty"] == "moderate":
            moderate_results.append(exec_results[i])

        if content["difficulty"] == "challenging":
            try:
                challenging_results.append(exec_results[i])
            except:
                print(i)

    simple_acc = sum([res["res"] for res in simple_results]) / len(simple_results)
    moderate_acc = sum([res["res"] for res in moderate_results]) / len(moderate_results)
    challenging_acc = sum([res["res"] for res in challenging_results]) / len(
        challenging_results
    )
    all_acc = sum(results) / num_queries
    count_lists = [
        len(simple_results),
        len(moderate_results),
        len(challenging_results),
        num_queries,
    ]
    return (
        simple_acc * 100,
        moderate_acc * 100,
        challenging_acc * 100,
        all_acc * 100,
        count_lists,
    )


class InputParams(argparse.Namespace):
    mode: str
    db_root_path: str
    dataset_json: str
    pred_sql: Optional[str]
    gold_sql: Optional[str]


def run_evaluation(input: InputParams):
    print("Input:", input)
    global exec_result

    # predict sqls
    pred_queries, db_paths = package_sqls(str(input.pred_sql), input.db_root_path)
    # generate ground truth sqls:
    gt_queries, _ = package_sqls(str(input.gold_sql), input.db_root_path)

    query_pairs = list(zip(pred_queries, gt_queries))

    run_sqls_parallel(
        query_pairs,
        db_places=db_paths,
        num_cpus=8,
        meta_time_out=30,
    )
    exec_result = sort_results(exec_result)
    print("start calculate")
    simple_acc, moderate_acc, challenging_acc, acc, count_lists = compute_acc_by_diff(
        exec_result, input.dataset_json
    )
    score_lists = [simple_acc, moderate_acc, challenging_acc, acc]
    print("EX on set")
    print("start calculate")
    print_data(score_lists, count_lists, metric="EX")
    print(
        "==========================================================================================="
    )
    print("Finished EX evaluation on set")
    print("\n\n")


@dataclass
class InputDatasetItem:
    question_id: int
    db_id: str
    question: str
    evidence: str
    difficulty: str
    SQL: str


def run_gen_sql(config: InputParams, item: InputDatasetItem) -> str:
    db_full_path = config.db_root_path + "/" + item.db_id + "/" + item.db_id + ".sqlite"
    db_full_path = os.path.abspath(db_full_path)
    db_uri = f"sqlite:///{db_full_path}"

    indexer = FxIndexer()
    indexer.connect_to_metadb(DBConfig(name=item.db_id, db_uri=db_uri))

    llm = LLM(LLMConfig(engine="OpenAI", engine_config={"openai_model": "gpt-4o-mini"}))

    agent = FxAgentText2SQL()
    result_sql = agent.invoke(
        configure=FxAgentRunnerConfig(llm, indexer),
        input=FxAgentText2SQLInput(input=item.question),
    ).value

    print("==============================")
    print(item.question_id, item.question)
    print("Pred:", result_sql)
    print("Gold:", item.SQL)
    print("")
    return result_sql


def dump_result(input: List[Tuple[str, str]], outfile: str):
    with open(outfile, "w", encoding="utf-8") as fout:
        for item in input:
            fout.write(f"{item[0]}\t{item[1]}\n")


def run_genereate_goal(input: InputParams):
    print("Input:", input)

    result_sqls: List[Tuple[str, str]] = []

    # read dataset from json
    with open(input.dataset_json, "r", encoding="utf-8") as fin:
        json_text = fin.read()
        json_data = json.loads(json_text)
        total = len(json_data)
        for json_item in json_data:
            item = InputDatasetItem(**json_item)
            print(item.question_id, "/", total)
            result_sql = run_gen_sql(input, item)
            result_sqls.append((result_sql, item.db_id))

    dump_result(result_sqls, "pred.sql")


def main():
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument("--mode", type=str, required=True, default="benchmark")
    args_parser.add_argument("--db_root_path", type=str, required=True, default="")
    args_parser.add_argument("--dataset_json", type=str, required=True, default="")
    args_parser.add_argument("--pred_sql", type=str, required=False)
    args_parser.add_argument("--gold_sql", type=str, required=False)
    args = cast(InputParams, args_parser.parse_args())

    if args.mode == "benchmark":
        if args.pred_sql is None or args.gold_sql is None:
            raise ValueError(f"Must input pred_sql and gold_sql.\n{args}")
        run_evaluation(args)
    elif args.mode == "gensql":
        run_genereate_goal(args)


if __name__ == "__main__":
    main()
