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

# The EXACT current count, not a loose floor. Slack is what lets a whole class
# vanish unnoticed: set this to 30 against an actual 48 and every anti-drift
# case — the ones that read the skill prose off disk, and the entire reason the
# CI step is gated on `markdown` as well as `swift` — could be deleted while
# both `make lint` and CI stayed green. An exact count also forces a one-line,
# diff-visible bump in the same commit that adds a test, which is the only
# enforcement a "remember to update this" comment ever really has.
#
# Currently: 38 in test_build_run_list.py + 11 in test_deliver_selection_prose.py
# + 15 in test_workflow_gates.py.
EXPECTED_MINIMUM = 64


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

    if not result.wasSuccessful():
        sys.exit(1)

    # Re-assert the floor against what actually EXECUTED. `wasSuccessful()`
    # counts a skip as a success, so a `@unittest.skip` on a class — or a
    # `raise unittest.SkipTest` in `setUpModule` — would keep both the
    # collection count and the exit status green while running no assertions
    # at all. That is the same "green means nobody looked" shape the collection
    # floor above exists to close, one step further along.
    executed = result.testsRun - len(result.skipped) - len(result.expectedFailures)
    if executed < EXPECTED_MINIMUM:
        print(
            f"run-script-tests: only {executed} of {count} tests actually ran "
            f"({len(result.skipped)} skipped), expected {EXPECTED_MINIMUM}.\n"
            "  A skipped suite passes without asserting anything — remove the skip, or\n"
            "  lower EXPECTED_MINIMUM deliberately if the tests were genuinely retired.",
            file=sys.stderr,
        )
        sys.exit(1)


if __name__ == "__main__":
    main()
