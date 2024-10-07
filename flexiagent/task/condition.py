from typing import Any, Dict, List, Literal, Optional, Tuple, Union

from pydantic import BaseModel

from flexiagent.llm.structured_schema import StructuredSchema


# special action output schema, when the result type is this, abort the action.
class TaskActionAbort(StructuredSchema):
    def __repr__(self):
        return str(type(self))


ConditionSupportOp = Literal["==", "!="]


class ConditionOp(BaseModel):
    path: str
    expected: Any
    op: ConditionSupportOp = "=="


class Condition(BaseModel):
    terms: List[Union[ConditionOp, Tuple[str, ConditionSupportOp, Any]]]
    mode: Literal["match_all", "match_one"] = "match_all"


class ConditionExecutor:
    def __init__(self, condition: Condition) -> None:
        self.condition = condition

    def _match_by_op(self, target: Any, op: ConditionSupportOp, expected: Any) -> bool:
        if op == "==":
            return target == expected
        elif op == "!=":
            return not (target == expected)
        else:
            raise ValueError(f"Unsupport op type, {op}")

    def _match_all(self, terms: List[ConditionOp], inputs: Dict[str, Any]) -> bool:
        for term in terms:
            path = term.path
            op = term.op
            expected = term.expected
            target_object = inputs
            path_arr = path.split(".")
            try:
                for path_step in path_arr:
                    if isinstance(target_object, dict):
                        target_object = target_object[path_step]
                    else:
                        target_object = getattr(target_object, path_step)
                if not self._match_by_op(target_object, op, expected):
                    # value not match
                    return False
            except Exception:
                # key not match
                return False
        # match all
        return True

    def _match_one(self, terms: List[ConditionOp], inputs: Dict[str, Any]) -> bool:
        for term in terms:
            path = term.path
            op = term.op
            expected = term.expected
            target_object = inputs
            path_arr = path.split(".")
            try:
                for path_step in path_arr:
                    if isinstance(target_object, dict):
                        target_object = target_object[path_step]
                    else:
                        target_object = getattr(target_object, path_step)
                if self._match_by_op(target_object, op, expected):
                    # match one
                    return True
            except Exception:
                # key not match
                pass
        # no one match
        return False

    def __call__(self, inputs: Dict[str, Any]) -> Optional[TaskActionAbort]:
        mode = self.condition.mode
        terms: List[ConditionOp] = []
        for term in self.condition.terms:
            if type(term) is ConditionOp:
                terms.append(term)
            elif isinstance(term, tuple):
                terms.append(ConditionOp(path=term[0], op=term[1], expected=term[2]))
            else:
                raise TypeError(f"Unsupport term type: {term}")
        if mode == "match_all":
            if self._match_all(terms, inputs):
                return None
            return TaskActionAbort()
        elif mode == "match_one":
            if self._match_one(terms, inputs):
                return None
            return TaskActionAbort()
        else:
            raise ValueError(f"Unsupport match mode, {mode}")
