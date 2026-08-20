#!/usr/bin/env python3
"""Run the `Scripts/tests` suites, and fail if it collected suspiciously few.

`python3 -m unittest discover` **exits 0 when it collects nothing**. Python 3.9's
`unittest/main.py` ends with `sys.exit(not self.result.wasSuccessful())`, and
`wasSuccessful()` is True when `testsRun == 0`; the `_NO_TESTS_EXITCODE = 5`
that would have caught it did not arrive until 3.12, and the `python3` on this
repo's PATH is Xcode's 3.9.6.

So a bare `discover` would let a renamed test file, a renamed directory, a wrong
working directory, or a file that stops matching the `test*.py` pattern turn the
gate into a no-op whose green is **byte-identical** to a passing suite. That is
the *False green* family this repo keeps hitting
(`knowledge/gotchas.md`), and `Scripts/check-fixtures.py` already
states the rule outright: a checker whose green is indistinguishable from "it
never ran" is not a checker.

The floor is a floor, not `> 0`, because the default `test*.py` pattern is itself
a silent filter: a future `Scripts/tests/build_run_list_test.py` would be
collected by nothing while the existing file keeps the count non-zero. Raise it
when suites are added — a drop is exactly the signal worth failing on.
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TESTS = ROOT / "Scripts" / "tests"

# Bump when suites are added. Lower than the current count only if tests are
# deliberately removed — never to make a red run go green.
EXPECTED_MINIMUM = 30


def main() -> None:
    if not TESTS.is_dir():
        print(f"run-script-tests: {TESTS} does not exist.", file=sys.stderr)
        sys.exit(1)

    suite = unittest.defaultTestLoader.discover(str(TESTS), top_level_dir=str(TESTS))

    # `discover` reports an import failure as a synthetic _FailedTest rather than
    # raising, so it would otherwise be counted as a collected test and run to a
    # normal red. That is fine — but it must not be mistaken for coverage.
    count = suite.countTestCases()
    if count < EXPECTED_MINIMUM:
        print(
            f"run-script-tests: collected {count} tests under {TESTS.relative_to(ROOT)}, "
            f"expected at least {EXPECTED_MINIMUM}.\n"
            "  A renamed file, a renamed directory, or a filename no longer matching the\n"
            "  `test*.py` discovery pattern silently empties this gate — and an empty run\n"
            "  exits 0 on Python 3.9, so it would look identical to a pass.",
            file=sys.stderr,
        )
        sys.exit(1)

    print(f"run-script-tests: {count} tests collected under {TESTS.relative_to(ROOT)}.")
    result = unittest.TextTestRunner(verbosity=1).run(suite)
    sys.exit(not result.wasSuccessful())


if __name__ == "__main__":
    main()
