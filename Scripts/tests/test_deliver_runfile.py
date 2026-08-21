"""Tests for Scripts/deliver-runfile.py — the self-verifying run-file writer.

Two kinds of case, deliberately:

  * CLI-contract cases run the real script in a subprocess, because exit codes
    ARE the contract — the /deliver conductor branches on them, and code 2
    (postcondition failed) must be distinguishable from code 1 (refused,
    nothing written).

  * A MUTATION case imports the module and suppresses `write_file`, proving
    the postcondition check can actually fail. A verifier only ever seen
    passing is exactly the blind-guard shape this repo keeps shipping
    (`knowledge/gotchas.md` → "A test that asserts on prose can be blind");
    the writer built to end that class must not repeat it.
"""

from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
SCRIPT = ROOT / "Scripts" / "deliver-runfile.py"


def load_module():
    spec = importlib.util.spec_from_file_location("deliver_runfile", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def run_cli(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), *args],
        capture_output=True,
        text=True,
        check=False,
    )


SAMPLE = {
    "id": "sample-run",
    "weight": "full",
    "reflexive": False,
    "reconciled": None,
    "deliverables": [
        {
            "title": "one",
            "issue": 490,
            "stamps": {"reviewedClean": None, "securityClean": None},
            "status": "open",
        }
    ],
}


class DeliverRunfileTests(unittest.TestCase):
    def setUp(self) -> None:
        import tempfile

        self._dir = tempfile.TemporaryDirectory()
        self.addCleanup(self._dir.cleanup)
        self.file = Path(self._dir.name) / "run.json"
        self.file.write_text(json.dumps(SAMPLE, indent=2))

    def read(self) -> dict:
        return json.loads(self.file.read_text())

    # -- set: the happy paths ------------------------------------------------

    def test_set_top_level_string(self) -> None:
        result = run_cli("set", str(self.file), "weight", "lite")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("verified: weight", result.stdout)
        self.assertEqual(self.read()["weight"], "lite")

    def test_set_nested_stamp_through_array_index(self) -> None:
        result = run_cli("set", str(self.file), "deliverables.0.stamps.reviewedClean", "abc123")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.read()["deliverables"][0]["stamps"]["reviewedClean"], "abc123")

    def test_set_json_typed_values(self) -> None:
        for raw, expected in [("true", True), ("null", None), ("42", 42), ('{"inScope": 1}', {"inScope": 1})]:
            with self.subTest(raw=raw):
                result = run_cli("set", str(self.file), "reconciled", raw)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(self.read()["reconciled"], expected)

    def test_set_new_final_key_is_allowed(self) -> None:
        result = run_cli("set", str(self.file), "deliverables.0.claimHandedBack", "2026-08-22T00:00:00Z")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.read()["deliverables"][0]["claimHandedBack"], "2026-08-22T00:00:00Z")

    def test_forced_string_via_explicit_json(self) -> None:
        result = run_cli("set", str(self.file), "weight", '"null"')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.read()["weight"], "null")

    # -- set: the refusals, all exit 1 with the file untouched ---------------

    def test_missing_intermediate_refused(self) -> None:
        before = self.read()
        result = run_cli("set", str(self.file), "selection.claimed", "true")
        self.assertEqual(result.returncode, 1)
        self.assertIn("does not exist", result.stderr)
        self.assertEqual(self.read(), before, "a refused write must leave the file untouched")

    def test_array_index_out_of_range_refused(self) -> None:
        result = run_cli("set", str(self.file), "deliverables.3.status", "open")
        self.assertEqual(result.returncode, 1)
        self.assertIn("out of range", result.stderr)

    def test_non_integer_array_segment_refused(self) -> None:
        result = run_cli("set", str(self.file), "deliverables.first.status", "open")
        self.assertEqual(result.returncode, 1)
        self.assertIn("integer index", result.stderr)

    def test_missing_file_refused(self) -> None:
        result = run_cli("set", str(self.file.parent / "absent.json"), "weight", "lite")
        self.assertEqual(result.returncode, 1)
        self.assertIn("does not exist", result.stderr)

    def test_invalid_json_file_refused_and_untouched(self) -> None:
        self.file.write_text("{not json")
        result = run_cli("set", str(self.file), "weight", "lite")
        self.assertEqual(result.returncode, 1)
        self.assertIn("not valid JSON", result.stderr)
        self.assertEqual(self.file.read_text(), "{not json")

    # -- get ----------------------------------------------------------------

    def test_get_reads_nested_value(self) -> None:
        result = run_cli("get", str(self.file), "deliverables.0.issue")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout), 490)

    def test_get_missing_path_is_an_error(self) -> None:
        result = run_cli("get", str(self.file), "deliverables.0.pr")
        self.assertEqual(result.returncode, 1)
        self.assertIn("does not exist", result.stderr)

    # -- the postcondition can actually fire ---------------------------------

    def test_postcondition_screams_when_the_write_is_suppressed(self) -> None:
        """Mutation check: no-op the write, the verifier must exit 2.

        This is the silent-refusal scenario from PR #474 reproduced on
        purpose — the environment swallows the write, nothing errors, and the
        only thing standing between that and a false "done" is the re-read.
        """
        module = load_module()
        module.write_file = lambda file, data: None
        with self.assertRaises(SystemExit) as caught:
            module.command_set(self.file, "weight", "lite")
        self.assertEqual(caught.exception.code, 2)
        self.assertEqual(self.read()["weight"], "full", "the suppressed write must not have landed")


if __name__ == "__main__":
    unittest.main()
