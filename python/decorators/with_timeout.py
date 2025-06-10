import concurrent.futures
import time
import functools

class TimeoutException(Exception):
    pass


def with_timeout(seconds):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            with concurrent.futures.ThreadPoolExecutor(max_workers=1) as executor:
                future = executor.submit(func, *args, **kwargs)
                try:
                    return future.result(timeout=seconds)
                except concurrent.futures.TimeoutError:
                    raise TimeoutException(f"Timeout atingido após {seconds} segundos")
                except Exception as e:
                  raise e
        return wrapper
    return decorator
