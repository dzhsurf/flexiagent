from functools import wraps


class HookObjectMethod:
    def __init__(self, obj, method_name, postprocess_hook):
        self.obj = obj
        self.method_name = method_name
        self.original_method = getattr(obj, method_name)
        self.postprocess_hook = postprocess_hook

    def __enter__(self):
        @wraps(self.original_method)
        async def new_method(*args, **kwargs):
            # call original method
            ret_value = self.original_method(*args, **kwargs)
            # call postprocess_hook
            return self.postprocess_hook(*ret_value)

        setattr(self.obj, self.method_name, new_method)

    def __exit__(self, exc_type, exc_value, traceback):
        setattr(self.obj, self.method_name, self.original_method)


class HookObjectAsyncMethod:
    def __init__(self, obj, method_name, postprocess_hook):
        self.obj = obj
        self.method_name = method_name
        self.original_method = getattr(obj, method_name)
        self.postprocess_hook = postprocess_hook

    def __enter__(self):
        print("HookAsyncMethod", self.method_name)

        @wraps(self.original_method)
        async def new_method(*args, **kwargs):
            # call original method
            ret_value = await self.original_method(*args, **kwargs)
            # call postprocess_hook
            return await self.postprocess_hook(*ret_value)

        setattr(self.obj, self.method_name, new_method)

    def __exit__(self, exc_type, exc_value, traceback):
        print("HookAsyncMethod recover original method", self.method_name)
        setattr(self.obj, self.method_name, self.original_method)
