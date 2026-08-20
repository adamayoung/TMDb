#!/usr/bin/env python3
"""Anti-drift tests for `/deliver`'s selection-policy prose.

There is no module under test here, and that is deliberate. `/deliver`'s
selection rules are *prose* — they are executed by a model reading
`.claude/skills/deliver/`, not by an interpreter. So the thing that can rot is
agreement **between prose files**, which is exactly the failure
`knowledge/gotchas.md` records as "a rule written in two files drifts, and the
copy you didn't edit is the one that wins" (PR #474: three instances, one a
security HIGH).

Every assertion therefore READS THE PROSE OFF DISK. Asserting against a string
literal here would make this file a further copy of the rule rather than a check
on the real ones — the same reasoning `test_build_run_list.py`'s `AntiDriftTests`
gives, and the reason `Scripts/check-prose-call-forms.py` greps prose too.

**Enumerate with `git ls-files`, never a filesystem glob.** `.claude/worktrees/`
is gitignored (`.gitignore:19`) but *present on disk*, and it holds a complete
second copy of every file asserted on here — one per in-flight `/deliver` run,
and concurrent runs are explicitly sanctioned. A `.claude/**/*.md` glob therefore
walks other branches' checkouts: red locally, green in CI, non-deterministically.
Asking git restores the invariant that the tracked tree is what is under test.

Each test carries a FLOOR — an assertion that it actually found something to
check. Without one, a renamed heading turns every test in this file green while
checking nothing, which is the *False green* family the same gotchas file opens
with.
"""

from __future__ import annotations

import json
import re
import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent

DELIVER = ROOT / ".claude" / "skills" / "deliver"
SKILL = DELIVER / "SKILL.md"
NEXT_MODE = DELIVER / "references" / "next-mode.md"
LIFECYCLE = DELIVER / "references" / "worktree-lifecycle.md"
PANEL = ROOT / ".claude" / "workflows" / "deliver-panel.js"

# The two selection-policy tokens. `next` is the legacy spelling and remains a
# policy token precisely so a pre-change run file (`"mode": "auto merge next"`)
# satisfies every gate predicate by construction, with no separate legacy clause.
POLICY_TOKENS = ("next", "explicit")

# The reflexive set, as a set of literal globs. Canonical definition lives in
# `deliver/SKILL.md` Phase 0; this list exists only to give the comparison a
# floor, and the tests below compare the three prose copies to EACH OTHER rather
# than to this tuple, so a deliberate change to the set does not have to be
# mirrored here.
REFLEXIVE_GLOB_RE = re.compile(r"`(\.claude/[a-z-]+/\*\*|\.github/CODE_REVIEW\.md)`")


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def tracked_markdown() -> list[Path]:
    """Every tracked markdown file that can carry a `parsed:` example."""
    out = subprocess.run(
        ["git", "ls-files", "-z", "*.md"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    return [ROOT / name for name in out.split("\0") if name]


def window(text: str, anchor: str, before: int = 6, after: int = 14) -> str | None:
    """The lines around the first line containing `anchor`, or None."""
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if anchor in line:
            return "\n".join(lines[max(0, i - before) : i + after])
    return None


def paragraph(text: str, anchor: str) -> str | None:
    """The blank-line-delimited paragraph containing `anchor`, or None.

    Preferred over `window()` for anything asserting a token is PRESENT. A fixed
    line window bleeds into its neighbours: SKILL.md's four gate predicates are
    consecutive bullets, so a 6-before/14-after window around one contains the
    next, and reverting a predicate left the test green because the token was
    still in view. A paragraph ends where the rule ends.
    """
    for para in re.split(r"\n\s*\n|\n(?=\s*(?:[-*+]|\d+\.)\s)", text):
        if anchor in para:
            return para
    return None


# The canonical way every gate predicate names its two policies. Asserting this
# phrase rather than the bare words is what stops `next` matching a
# `references/next-mode.md` link and `explicit` matching the word "explicitly" —
# the same substring trap this file's own policy-name test guards against.
BOTH_TOKENS = "(`next` or `explicit`)"


class GatePredicateTests(unittest.TestCase):
    """The four gates that ask "was this a selection run?".

    This is the highest-blast-radius half of the selection feature and the half
    with no other executable check. Each predicate must name BOTH policy tokens:
    naming only `next` silently excludes every explicit-policy run, and the two
    documented symptoms are invisible — a board claim stranded in `In progress`
    forever (Phase 1), and an unattended squash-merge of a reflexive change that
    nobody read (Phase 10).
    """

    # (human name, a stable anchor phrase in the predicate's own sentence)
    GATES = (
        ("Phase 1 stranded-claim sweep", "Release stranded"),
        ("Phase 6 selection gate", "`selection` missing or empty"),
        ("Phase 6 planReview stop", "`planReview` missing"),
        ("Phase 10 merge-drop", "dropped, not honoured"),
    )

    # Restatements of the same predicates in the reference files. `SKILL.md`
    # holds the primary statement, but a conductor following SKILL.md's own link
    # lands in these — so a copy keyed on `next` alone silently exempts every
    # explicit run from the gate it is reading about.
    RESTATEMENTS = (
        ("next-mode.md §5b Phase 10 backstop", NEXT_MODE, "Phase 10 drops"),
        ("worktree-lifecycle.md Phase 1 sweep", LIFECYCLE, "Release stranded"),
        ("worktree-lifecycle.md Phase 6 gate", LIFECYCLE, "Phase 6 hard-stops"),
    )

    def test_reference_restatements_name_both_policy_tokens(self):
        located = {}
        for name, path, anchor in self.RESTATEMENTS:
            located[name] = paragraph(read(path), anchor)
        missing = [n for n, r in located.items() if r is None]
        self.assertEqual(
            missing,
            [],
            msg=(
                f"Could not locate these gate restatements: {missing}. They carry the same "
                f"rule as SKILL.md's primary statements; if one was removed, drop it from "
                f"RESTATEMENTS in the same commit rather than leaving this test blind."
            ),
        )
        for name, region in located.items():
            with self.subTest(restatement=name):
                self.assertTrue(
                    BOTH_TOKENS in region,
                    msg=(
                        f"{name} does not name both policies as {BOTH_TOKENS}. A conductor "
                        f"reading this copy would conclude the gate does not apply.\n"
                        f"Region was:\n{region}"
                    ),
                )

    def test_every_gate_predicate_names_both_policy_tokens(self):
        text = read(SKILL)
        # Count anchors located BEFORE asserting on them. Incrementing after the
        # assertions would make the floor unreachable the moment any gate fails,
        # reporting "0 of 4 checked" — a confusing second failure that hides the
        # real one.
        located = {name: paragraph(text, anchor) for name, anchor in self.GATES}
        missing = [name for name, region in located.items() if region is None]
        self.assertEqual(
            missing,
            [],
            msg=(
                f"Could not locate these gate predicates in {SKILL.name}: {missing}. "
                f"Either the gate was removed or its wording changed — update the anchor in "
                f"GATES in the same commit, or this file silently stops checking it."
            ),
        )
        for name, region in located.items():
            with self.subTest(gate=name):
                self.assertTrue(
                    BOTH_TOKENS in region,
                    msg=(
                        f"The {name} predicate does not name both selection policies as "
                        f"{BOTH_TOKENS}, so it does not demonstrably fire for both.\n"
                        f"Predicate paragraph was:\n{region}"
                    ),
                )


class ReflexiveSetTests(unittest.TestCase):
    """The reflexive glob set is quoted in three prose files.

    `SKILL.md` claimed it was quoted in "exactly one other place" while a third
    copy in `worktree-lifecycle.md` had already drifted — missing
    `.claude/workflows/**`, the glob whose absence would let a rewrite of the
    panel script itself be auto-merged. The prose cross-reference PR #474 added
    for this exact class did not survive one delivery, so it is asserted here.
    """

    SOURCES = (("SKILL.md Phase 0", SKILL), ("next-mode.md 5b", NEXT_MODE), ("worktree-lifecycle.md", LIFECYCLE))

    def _globs(self, path: Path) -> set[str]:
        """Globs from every paragraph that both says "reflexive" and lists one.

        Anchoring on the FIRST "reflexive" in the file does not work: in
        `next-mode.md` that is a §5 cross-reference ("breaking (§5a), reflexive
        (§5b)") twelve lines from any glob, so the window came back empty and the
        test reported a missing copy that is actually present. Scoping to
        blank-line-separated paragraphs finds the definition wherever it sits,
        and requiring BOTH the word and a glob keeps unrelated prose out.
        """
        found: set[str] = set()
        for para in re.split(r"\n\s*\n", read(path)):
            if "reflexive" not in para.lower():
                continue
            found |= set(REFLEXIVE_GLOB_RE.findall(para))
        return found

    def test_all_three_copies_list_the_same_globs(self):
        found = {name: self._globs(path) for name, path in self.SOURCES}
        for name, globs in found.items():
            self.assertTrue(
                globs,
                msg=(
                    f"No reflexive-set globs found near the word 'reflexive' in {name}. "
                    f"If that copy was deliberately removed, delete it from SOURCES in the "
                    f"same commit — an empty set here would otherwise compare equal to nothing."
                ),
            )
        reference_name, reference = next(iter(found.items()))
        for name, globs in found.items():
            self.assertEqual(
                globs,
                reference,
                msg=(
                    f"The reflexive set in {name} differs from {reference_name}.\n"
                    f"  {name}: {sorted(globs)}\n"
                    f"  {reference_name}: {sorted(reference)}\n"
                    f"A drifted copy does not lag — the reader picks one, so it OVERRIDES."
                ),
            )

    def test_the_workflows_glob_is_present_everywhere(self):
        # Called out on its own because this is the glob that actually drifted,
        # and its absence is what would permit an unattended merge of a change
        # to the panel script that authorises unattended merges.
        for name, path in self.SOURCES:
            with self.subTest(source=name):
                self.assertTrue(
                    "`.claude/workflows/**`" in read(path),
                    msg=f"{name} omits `.claude/workflows/**` from the reflexive set.",
                )


class EchoFieldTests(unittest.TestCase):
    """No `parsed:` example may still advertise the retired `next=` field."""

    def test_no_tracked_markdown_carries_a_retired_next_field(self):
        offenders = []
        examples = 0
        for path in tracked_markdown():
            for line in read(path).splitlines():
                if "parsed:" not in line:
                    continue
                examples += 1
                if re.search(r"\bnext=", line):
                    offenders.append(f"{path.relative_to(ROOT)}: {line.strip()}")
        self.assertGreater(
            examples,
            0,
            msg=(
                "Found no `parsed:` example in the tracked tree at all. This test would then "
                "pass while checking nothing — if the echo was renamed, rename it here too."
            ),
        )
        self.assertEqual(
            offenders,
            [],
            msg="These `parsed:` examples still carry the retired `next=` field:\n" + "\n".join(offenders),
        )


class RunFileSchemaTests(unittest.TestCase):
    """The run-file JSON example must stay machine-valid and self-consistent."""

    def _example(self) -> str:
        text = read(LIFECYCLE)
        blocks = re.findall(r"```json\n(.*?)```", text, flags=re.DOTALL)
        self.assertTrue(
            blocks,
            msg=f"{LIFECYCLE.name} carries no ```json block — the run-file example is the schema's only worked copy.",
        )
        return blocks[0]

    def test_run_file_example_is_valid_json(self):
        raw = self._example()
        try:
            parsed = json.loads(raw)
        except json.JSONDecodeError as exc:
            self.fail(f"The run-file example in {LIFECYCLE.name} is not valid JSON: {exc}")
        self.assertIn("mode", parsed, msg="The run-file example lost its `mode` field, which all four gates read.")

    def test_run_file_example_mode_names_a_policy_token(self):
        parsed = json.loads(self._example())
        mode = parsed.get("mode") or ""
        self.assertTrue(
            any(token in mode.split() for token in POLICY_TOKENS),
            msg=(
                f"The run-file example's mode is {mode!r}, which names no selection-policy token "
                f"({', '.join(POLICY_TOKENS)}). The example is what a reader copies."
            ),
        )


class InvocationGrammarTests(unittest.TestCase):
    """`issue` is a keyword taking one operand; both policies are documented."""

    def test_skill_documents_the_issue_keyword(self):
        # Scope to the Invocation heading's own section. Over the whole file this
        # passes on the run file's `issue: <number>` field and other incidental
        # uses, i.e. with the keyword entirely removed.
        section = window(read(SKILL), "## Invocation", before=0, after=45) or ""
        self.assertTrue(
            re.search(r"`issue` takes exactly one operand", section) is not None,
            msg=f"{SKILL.name}'s Invocation section does not define the `issue` keyword and its operand.",
        )

    def test_next_mode_names_both_policies(self):
        text = read(NEXT_MODE)
        # Backticked, so "explicitly" in unrelated prose cannot satisfy it.
        for policy in ("`top-of-run-list`", "`explicit`"):
            with self.subTest(policy=policy):
                self.assertTrue(
                    policy in text,
                    msg=f"{NEXT_MODE.name} does not name the {policy} selection policy.",
                )

    def test_panel_brief_covers_a_user_named_issue(self):
        text = read(PANEL)
        self.assertTrue(
            "phase0n-selection" in text,
            msg="The phase0n-selection point vanished; deliver-panel.js throws on an unlisted point.",
        )
        # Scope to the point's OWN brief. Asserting over the whole file passes on
        # `phase0-no-acs`'s unrelated phrase "an explicit test list", so the
        # check would survive reverting the entire rewrite.
        brief = window(text, "'phase0n-selection'", before=0, after=3) or ""
        self.assertTrue(
            re.search(r"named|explicit", brief) is not None,
            msg=(
                "phase0n-selection's brief does not distinguish an issue the run picked from one "
                "the user named, so jurors are briefed on the wrong question."
            ),
        )


if __name__ == "__main__":
    unittest.main()
