import pytest


def pytest_sessionfinish(session, exitstatus):
    """
    This hook is called after the whole test run finishes.
    :param session: The pytest session object.
    :param exitstatus: Exit status code.
    """
    total = session.testscollected
    passed = len(
        [
            i
            for i in session.config.cache.get("cache/lastfailed", {})
            if session.config.cache.get("cache/lastfailed", [])[i] is False
        ]
    )
    failed = session.testsfailed
    skipped = session.config.cache.get("cache/skipped", 0)

    print("\n===== Test Summary =====")
    print(f"Total tests: {total}")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    print(f"Skipped: {skipped}")
    print(f"Exit status: {exitstatus}")
