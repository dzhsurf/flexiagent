import logging
from typing import Any, List, Literal, Tuple
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
    logger.info(f"\n[====\tpass: {passed}\tfail: {failed}\tacc: {acc:.2f}====]\n")
    return ans
