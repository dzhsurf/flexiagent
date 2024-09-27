from abc import ABC, abstractmethod
from typing import Any, Callable, Optional


class FxTask(ABC):
    def __init__(
        self,
        *,
        preprocess_hook: Optional[Callable] = None,
        postprocess_hook: Optional[Callable] = None,
    ):
        super().__init__()
        self.preprocess_hook = preprocess_hook
        self.postprocess_hook = postprocess_hook

    @abstractmethod
    def process(self, *args: Any, **kwds: Any) -> Any:
        pass

    def should_process(self, *args: Any, **kwds: Any) -> bool:
        return True

    def fallback_process(self, *args: Any, **kwds: Any) -> Any:
        return None

    def invoke(self, *args: Any, **kwds: Any):
        if self.preprocess_hook:
            args, kwds = self.preprocess_hook(*args, **kwds)

        if self.should_process(*args, **kwds):
            result = self.process(*args, **kwds)
            if self.postprocess_hook:
                result = self.postprocess_hook(result)
            return result
        else:
            return self.fallback_process(*args, **kwds)
