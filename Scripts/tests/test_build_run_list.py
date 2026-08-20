#!/usr/bin/env python3
"""Tests for `Scripts/build_run_list.py`.

Two distinct jobs here, and the second is the one that is easy to get wrong.

**Behaviour** — the ordering rules, each in isolation. The interesting cases are
the two the plan review caught: a plain greedy topological sort does NOT promote
an unblocker (`test_p2_unblocking_a_p0_precedes_an_independent_p1`), and a
contention pass that swaps the contending pair with each other leaves it adjacent
(`test_a_non_contender_is_moved_between_two_contending_issues`).

**Anti-drift** — asserting the built line against a string literal *here* would
make this file a second copy of the grammar, not a check on the real ones. So the
format cases assert against `RUN_LIST_RE` exported by the module under test, and
the prose cases READ THE SKILL FILES OFF DISK. That is what makes
`knowledge/gotchas.md`'s "a rule written in two files drifts" detectable by a
test rather than only by a cross-reference. Precedent for a check that greps
prose: `Scripts/check-prose-call-forms.py`.
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(ROOT / "Scripts"))

import build_run_list as brl  # noqa: E402

NEXT_MODE = ROOT / ".claude" / "skills" / "deliver" / "references" / "next-mode.md"
TRIAGE_SKILL = ROOT / ".claude" / "skills" / "triage-issues" / "SKILL.md"

HEAD = "36552a4d"


def issue(number, priority="P1", size="S", depends_on=(), files=None):
    """Build one Ready-set element. `files=None` models a SKIPPED issue.

    A skipped issue's marker carries `deps=`, `priority` and `size` but no
    `filesTouched`, so it contributes no contention edges — the distinction the
    `noEdgeData` case turns on.
    """
    item = {
        "issue": number,
        "priority": priority,
        "size": size,
        "dependsOn": list(depends_on),
    }
    if files is not None:
        item["filesTouched"] = list(files)
    return item


def order(ready, closed=()):
    return brl.build(HEAD, ready, closed=closed)["ordered"]


class DependencyOrderTests(unittest.TestCase):
    def test_a_dependency_precedes_its_dependent(self):
        ready = [issue(100, depends_on=[200]), issue(200)]
        self.assertEqual(order(ready), [200, 100])

    def test_p2_unblocking_a_p0_precedes_an_independent_p1(self):
        # SKILL.md:207 — "Rule 1 outranks rule 2: a P2 that unblocks a P0 goes
        # first." Plain greedy Kahn's emits 437, 430, 426 here, because 430's OWN
        # priority is P2. Only effective priority (min over transitive
        # dependents) promotes it.
        ready = [
            issue(430, priority="P2", depends_on=[]),
            issue(426, priority="P0", depends_on=[430]),
            issue(437, priority="P1"),
        ]
        self.assertEqual(order(ready), [430, 426, 437])

    def test_effective_priority_propagates_transitively(self):
        # 300 <- 301 <- 302(P0). 300 must be promoted by its GRANDCHILD.
        ready = [
            issue(300, priority="P2"),
            issue(301, priority="P2", depends_on=[300]),
            issue(302, priority="P0", depends_on=[301]),
            issue(310, priority="P1"),
        ]
        self.assertEqual(order(ready), [300, 301, 302, 310])

    def test_deps_outranking_priority_is_reported(self):
        ready = [
            issue(430, priority="P2"),
            issue(426, priority="P0", depends_on=[430]),
        ]
        result = brl.build(HEAD, ready)
        self.assertIn({"before": 430, "after": 426}, result["depsOutrankPriority"])

    def test_no_deps_outrank_report_when_priorities_agree(self):
        ready = [issue(1, priority="P0"), issue(2, priority="P1", depends_on=[1])]
        self.assertEqual(brl.build(HEAD, ready)["depsOutrankPriority"], [])


class PrioritySizeTiebreakTests(unittest.TestCase):
    def test_priority_orders_before_size(self):
        ready = [issue(1, priority="P2", size="XS"), issue(2, priority="P0", size="L")]
        self.assertEqual(order(ready), [2, 1])

    def test_size_ascending_within_a_priority_band(self):
        ready = [issue(1, size="L"), issue(2, size="XS"), issue(3, size="M")]
        self.assertEqual(order(ready), [2, 3, 1])

    def test_issue_number_ascending_is_the_final_tiebreak(self):
        ready = [issue(9), issue(3), issue(7)]
        self.assertEqual(order(ready), [3, 7, 9])

    def test_reproduces_the_published_2026_08_20_run_list(self):
        # The real Ready set from the 2026-08-20 status update. That run had no
        # dependency edges and no contention, so this pins rules 2-4 against
        # real data; rules 1 and 3 are covered by the synthetic cases above.
        published = [434, 426, 437, 448, 428, 454, 424, 425, 427, 429, 435, 467, 430]
        ready = [
            issue(434, "P0", "S"), issue(426, "P0", "M"), issue(437, "P0", "M"),
            issue(448, "P1", "XS"), issue(428, "P1", "S"), issue(454, "P1", "S"),
            issue(424, "P1", "M"), issue(425, "P1", "M"), issue(427, "P1", "L"),
            issue(429, "P1", "L"), issue(435, "P2", "XS"), issue(467, "P2", "S"),
            issue(430, "P2", "L"),
        ]
        self.assertEqual(order(ready), published)


class ContentionTests(unittest.TestCase):
    def test_a_non_contender_is_moved_between_two_contending_issues(self):
        # 1 and 2 contend. Swapping them with each other would leave them
        # adjacent — the separation must bring 3 in.
        ready = [
            issue(1, size="XS", files=["a.swift"]),
            issue(2, size="S", files=["a.swift"]),
            issue(3, size="M", files=["b.swift"]),
        ]
        result = brl.build(HEAD, ready)
        self.assertEqual(result["ordered"], [1, 3, 2])
        self.assertEqual(result["unseparableContention"], [])

    def test_contention_never_moves_an_item_across_a_priority_band(self):
        # 1 and 2 contend, but the only non-contender is a P2. Rule 2 outranks
        # rule 3, so the pair stays adjacent and is REPORTED instead.
        ready = [
            issue(1, priority="P0", size="XS", files=["a.swift"]),
            issue(2, priority="P0", size="S", files=["a.swift"]),
            issue(3, priority="P2", size="M", files=["b.swift"]),
        ]
        result = brl.build(HEAD, ready)
        self.assertEqual(result["ordered"], [1, 2, 3])
        self.assertEqual(result["unseparableContention"], [[1, 2]])

    def test_an_unseparable_pair_is_reported(self):
        ready = [
            issue(1, files=["a.swift"]),
            issue(2, files=["a.swift"]),
        ]
        result = brl.build(HEAD, ready)
        self.assertEqual(result["ordered"], [1, 2])
        self.assertEqual(result["unseparableContention"], [[1, 2]])

    def test_contention_pass_is_idempotent(self):
        ready = [
            issue(1, size="XS", files=["a.swift"]),
            issue(2, size="S", files=["a.swift"]),
            issue(3, size="M", files=["b.swift"]),
        ]
        once = brl.build(HEAD, ready)["ordered"]
        # Re-feed the produced order back in; the pass must be a fixed point.
        by_number = {i["issue"]: i for i in ready}
        twice = brl.build(HEAD, [by_number[n] for n in once])["ordered"]
        self.assertEqual(once, twice)

    def test_skipped_issues_contribute_no_contention_edges(self):
        # Both touch a.swift, but neither declares filesTouched (skipped), so
        # there is no edge to detect and nothing to separate.
        ready = [issue(1, size="XS"), issue(2, size="S"), issue(3, size="M")]
        result = brl.build(HEAD, ready)
        self.assertEqual(result["ordered"], [1, 2, 3])
        self.assertEqual(result["unseparableContention"], [])

    def test_separation_never_violates_dependency_order(self):
        # 1 and 2 contend; 3 would separate them but 3 depends on 2, so moving
        # 3 before 2 is illegal. 4 is the legal separator.
        ready = [
            issue(1, size="XS", files=["a.swift"]),
            issue(2, size="S", files=["a.swift"]),
            issue(3, size="M", depends_on=[2], files=["b.swift"]),
            issue(4, size="L", files=["c.swift"]),
        ]
        result = brl.build(HEAD, ready)
        self.assertEqual(result["ordered"], [1, 4, 2, 3])
        self.assertEqual(result["unseparableContention"], [])


class ErrorTests(unittest.TestCase):
    def test_a_cycle_is_an_error_naming_the_nodes(self):
        ready = [issue(1, depends_on=[2]), issue(2, depends_on=[1])]
        with self.assertRaises(brl.RunListError) as ctx:
            brl.build(HEAD, ready)
        self.assertIn("1", str(ctx.exception))
        self.assertIn("2", str(ctx.exception))

    def test_an_edge_onto_an_unknown_issue_is_an_error(self):
        # Neither Ready nor declared closed: this is Phase 5's Ready-demotion
        # rule violated — a Ready issue depending on something not landing.
        ready = [issue(1, depends_on=[999])]
        with self.assertRaises(brl.RunListError) as ctx:
            brl.build(HEAD, ready)
        self.assertIn("999", str(ctx.exception))

    def test_an_edge_onto_a_closed_issue_is_discharged(self):
        ready = [issue(1, depends_on=[999])]
        result = brl.build(HEAD, ready, closed=[999])
        self.assertEqual(result["ordered"], [1])
        self.assertEqual(result["dischargedEdges"], [{"from": 1, "to": 999}])

    def test_a_bad_priority_is_an_error(self):
        with self.assertRaises(brl.RunListError):
            brl.build(HEAD, [issue(1, priority="P9")])

    def test_a_bad_size_is_an_error(self):
        with self.assertRaises(brl.RunListError):
            brl.build(HEAD, [issue(1, size="XXL")])

    def test_a_non_integer_issue_number_is_an_error(self):
        with self.assertRaises(brl.RunListError):
            brl.build(HEAD, [issue("426")])

    def test_a_duplicate_issue_number_is_an_error(self):
        with self.assertRaises(brl.RunListError):
            brl.build(HEAD, [issue(1), issue(1)])

    def test_a_bad_head_sha_is_an_error(self):
        for bad in ("", "not-a-sha", "ABCDEF1", "36552a"):
            with self.subTest(head=bad), self.assertRaises(brl.RunListError):
                brl.build(bad, [issue(1)])

    def test_an_empty_ready_set_returns_a_note_and_no_line(self):
        # Never `<!-- run-list: <sha> | -->` — the parser would accept that as a
        # well-formed empty run-list, which is worse than no line at all.
        result = brl.build(HEAD, [])
        self.assertEqual(result["ordered"], [])
        self.assertIsNone(result["runListLine"])
        self.assertTrue(result["note"])


class LineFormatTests(unittest.TestCase):
    def test_line_matches_the_exported_regex(self):
        line = brl.build_run_list_line(HEAD, [426, 437, 448])
        self.assertRegex(line, brl.RUN_LIST_RE)

    def test_exact_byte_format(self):
        self.assertEqual(
            brl.build_run_list_line(HEAD, [426, 437]),
            f"<!-- run-list: {HEAD} | 426,437 -->",
        )

    def test_same_input_twice_is_byte_identical(self):
        ready = [issue(9), issue(3, depends_on=[7]), issue(7)]
        first = brl.build(HEAD, ready)["runListLine"]
        second = brl.build(HEAD, ready)["runListLine"]
        self.assertEqual(first, second)

    def test_regex_rejects_the_near_misses_that_motivated_this(self):
        # Each of these is a plausible LLM rewording of the line. All must fail
        # the parse rather than half-match — that is the whole point of #471.
        for bad in (
            f"<!-- run-list: {HEAD} | 426, 437 -->",
            f"<!-- run-list: {HEAD} | #426,#437 -->",
            f"<!-- run-list: {HEAD} | 426,437 -->.",
            f"<!-- run-list:{HEAD} | 426,437 -->",
            f"<!-- run-list: {HEAD} | -->",
        ):
            with self.subTest(line=bad):
                self.assertNotRegex(bad, brl.RUN_LIST_RE)


class AntiDriftTests(unittest.TestCase):
    """The grammar is stated in code and quoted in prose. Prove the prose still
    agrees, so a drifted copy fails a test instead of being read by a human who
    picks the wrong one."""

    def test_next_mode_still_carries_the_grammar_markers(self):
        text = NEXT_MODE.read_text(encoding="utf-8")
        self.assertIn("<!-- run-list: ", text)
        self.assertIn(" -->", text)

    def test_next_mode_names_the_builder_as_the_definition(self):
        text = NEXT_MODE.read_text(encoding="utf-8")
        self.assertIn("build_run_list_line", text)

    def test_triage_skill_phase_8_names_the_builder(self):
        text = TRIAGE_SKILL.read_text(encoding="utf-8")
        self.assertIn("build_run_list_line", text)

    def test_next_modes_example_line_parses(self):
        # Pull the documented example straight out of the prose and run it
        # through the real parser. If someone edits the example into something
        # the parser rejects, this fails.
        text = NEXT_MODE.read_text(encoding="utf-8")
        examples = [
            line.strip()
            for line in text.splitlines()
            if line.strip().startswith("<!-- run-list:")
        ]
        self.assertTrue(examples, "next-mode.md carries no run-list example line")
        for example in examples:
            with self.subTest(example=example):
                self.assertRegex(example, brl.RUN_LIST_RE)


if __name__ == "__main__":
    unittest.main()
