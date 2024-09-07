# TODO: ...
# official: https://bird-bench.github.io/

# dataset
# dev-set: https://bird-bench.oss-cn-beijing.aliyuncs.com/dev.zip
# train-set: https://bird-bench.oss-cn-beijing.aliyuncs.com/train.zip

# evaluation suite: https://github.com/bird-bench/mini_dev/tree/main
# code copy from bird-bench/mini_dev/llm/src/evaluation_ex.py

import argparse
import sys
import json
import sqlite3
import multiprocessing as mp
from typing import Any, Dict, Tuple
from func_timeout import func_timeout, FunctionTimedOut

#### utils


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


def package_sqls(
    sql_path: str,
    db_root_path: str,
    sql_dialect: str = "SQLite",
) -> Tuple[Any, Any]:
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
    except Exception as e:
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


if __name__ == "__main__":
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument(
        "--predicted_sql_path", type=str, required=True, default=""
    )
    args_parser.add_argument("--ground_truth_path", type=str, required=True, default="")
    # args_parser.add_argument("--data_mode", type=str, required=True, default="dev")
    args_parser.add_argument("--db_root_path", type=str, required=True, default="")
    args_parser.add_argument("--diff_json_path", type=str, required=True, default="")
    args_parser.add_argument("--num_cpus", type=int, default=1)
    args_parser.add_argument("--meta_time_out", type=float, default=30.0)
    args_parser.add_argument("--sql_dialect", type=str, default="SQLite")
    # args_parser.add_argument("--mode_gt", type=str, default="gt")
    # args_parser.add_argument("--mode_predict", type=str, default="gpt")
    # args_parser.add_argument("--difficulty", type=str, default="simple")
    # args_parser.add_argument("--engine", type=str, default="")
    args = args_parser.parse_args()

    ####
    exec_result = []

    # predict sqls
    pred_queries, db_paths = package_sqls(
        args.predicted_sql_path,
        args.db_root_path,
        sql_dialect=args.sql_dialect,
    )
    # generate ground truth sqls:
    gt_queries, db_paths_gt = package_sqls(
        args.ground_truth_path,
        args.db_root_path,
        sql_dialect=args.sql_dialect,
    )

    query_pairs = list(zip(pred_queries, gt_queries))

    run_sqls_parallel(
        query_pairs,
        db_places=db_paths,
        num_cpus=args.num_cpus,
        meta_time_out=args.meta_time_out,
        sql_dialect=args.sql_dialect,
    )
    exec_result = sort_results(exec_result)
    print("start calculate")
    simple_acc, moderate_acc, challenging_acc, acc, count_lists = compute_acc_by_diff(
        exec_result, args.diff_json_path
    )
    score_lists = [simple_acc, moderate_acc, challenging_acc, acc]
    print(f"EX on {args.sql_dialect} set")
    print("start calculate")
    print_data(score_lists, count_lists, metric="EX")
    print(
        "==========================================================================================="
    )
    print(f"Finished EX evaluation on {args.sql_dialect} set")
    print("\n\n")
