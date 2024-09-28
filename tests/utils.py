from abc import ABC, abstractmethod
import logging
from typing import Any, Dict, List, Literal, Tuple
from pydantic import BaseModel
from sqlalchemy import create_engine, text

logger = logging.getLogger(__name__)

DBDialect = Literal["SQLite"]


class SQLExecuteParams(BaseModel):
    db_uri: str
    sql: str


class DatasetItem(BaseModel):
    question_id: str
    question: str
    sql: str
    db_id: str
    db_uri: str  # currently only support SQLite


class DatasetProvider(ABC):
    @abstractmethod
    def setup(self, dataset_path: str):
        pass

    @abstractmethod
    def get_all_dataset_items(self) -> List[DatasetItem]:
        pass


def get_dialect_from_uri(db_uri: str) -> DBDialect:
    if db_uri.startswith("sqlite://"):
        return "SQLite"
    raise ValueError(f"Unknow db_type, {db_uri}")


def _sqlite_execute(db_uri: str, sql: str) -> List[Any]:
    ans = []
    engine = create_engine(db_uri)
    with engine.connect() as connection:
        query = text(sql)
        result = connection.execute(query)
        for row in result.fetchall():
            ans.append(row)
    return ans


def _db_execute(db_uri: str, sql: str) -> List[Any]:
    dialect = get_dialect_from_uri(db_uri)
    if dialect == "SQLite":
        return _sqlite_execute(db_uri, sql)
    else:
        raise ValueError(f"Unsupport db type. {dialect}")


# execution accuracy
def execution_accuracy(
    pred_sqls: List[SQLExecuteParams],
    gold_sqls: List[SQLExecuteParams],
    force_run: bool = False,
) -> List[bool]:
    if len(pred_sqls) != len(gold_sqls):
        logger.error(
            f"pred_sqls ({len(pred_sqls)}) not equal gold_sqls ({len(gold_sqls)})."
        )
        if not force_run:
            return []

    # run db execute
    total_res: List[Tuple[List[Any], List[Any]]] = []
    for pred, gold in zip(pred_sqls, gold_sqls):
        pred_res = _db_execute(pred.db_uri, pred.sql)
        gold_res = _db_execute(gold.db_uri, gold.sql)
        total_res.append((pred_res, gold_res))
        # logger.info("===pred===")
        # logger.info("uri: %s sql: %s", pred.db_uri, pred.sql)
        # logger.info(pred_res)
        # logger.info("===gold===")
        # logger.info("uri: %s sql: %s", gold.db_uri, gold.sql)
        # logger.info(gold_res)

    # compute accuracy
    passed = 0
    failed = 0
    ans: List[bool] = []
    for pred_res, gold_res in total_res:
        is_match = set(pred_res) == set(gold_res)
        ans.append(is_match)
        if is_match:
            passed += 1
        else:
            failed += 1
    acc = passed / (passed + failed)
    logger.info(f"\n[====\tpass: {passed}\tfail: {failed}\tacc: {acc:.2f}\t====]\n")
    return ans


def config_logger_level():
    logging.getLogger("httpx").setLevel(logging.WARNING)
    logging.getLogger("flexiagent").setLevel(logging.WARNING)
    logging.basicConfig(
        format="%(asctime)s - %(levelname)s - %(funcName)s - %(message)s",
        level=logging.INFO,
    )


def pretty_log(msg: str) -> str:
    msg = f"\n--------\n{msg}\n--------"
    return msg


def trace_dag_context(context: Dict[str, List[str]]) -> List[str]:
    # traverse trace path
    results: List[str] = []

    def dfs(node_key: str, input_paths: List[str]):
        input_paths += [node_key]
        if node_key in context:
            for neighbor_k in context[node_key]:
                dfs(neighbor_k, input_paths)
        else:
            results.append(",".join(input_paths[::-1]))
        input_paths.pop(-1)

    for k, _ in context.items():
        if k.endswith("_call"):
            continue
        dfs(k, [])

    # remove dup
    remove_items: List[str] = []
    results = sorted(results)
    for i in range(len(results)):
        item1 = results[i]
        for j in range(i + 1, len(results)):
            item2 = results[j]
            if item2.startswith(item1):
                remove_items.append(item1)
                break
    final_results = set(results)
    for item in remove_items:
        final_results.remove(item)

    final_list: List[str] = []
    for item in final_results:
        arr = item.split(",")
        items: List[str] = []
        for arr_item in arr:
            k = arr_item + "_call"
            if k in context:
                call_step = context[k][0]
                items.append(f"{arr_item} ({call_step})")
            else:
                items.append(arr_item)
        final_list.append(" -> ".join(items))

    # output trace path
    return sorted(final_list)
