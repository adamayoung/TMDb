#!/usr/bin/env python3
"""Anti-drift tests for the workflows' cache keys and change gates (issue #448).

There is no module under test. What can rot here is *GitHub Actions configuration*,
and it rots in two specific ways this repo has already been bitten by.

**1. A cache key that degrades to a constant.** `hashFiles(glob)` returns the empty
string when the glob matches nothing — it does not error. Three keys hashed
`'**/Package.resolved'`, a file that is `.gitignore`d and has never been tracked, so
each key collapsed to a constant (`macOS-swift-`, `macOS-docs-`) that was *byte-identical
to its own `restore-keys` prefix*. `actions/cache` skips the save on an exact
primary-key hit, so those caches were written once and never refreshed: measured
2026-08-21, `macOS-swift-` on `refs/heads/main` was created 2026-04-26 and had not been
re-saved in 117 days. `knowledge/gotchas.md` records the mechanism and the rule this
file makes executable — *sanity-check any computed key against its degenerate value
before trusting it*.

`evaluate()` below IS that rule as code: it substitutes `hashFiles(g) -> ''` for any
glob matching no tracked file, and the tests then assert a hash survives.

**2. A change gate that silently stops gating.** `ci.yml`'s three build jobs are
`if: always()` at job level with every real step gated on `needs.changes.outputs.swift`,
and the `ci` aggregate fails only on `failure`/`cancelled` — so a job that runs and
skips every step reports **success**. Over-pruning the `swift` paths filter would
therefore turn the build matrix off while the required check stayed green. And every
step in the `Lint` job — *including `Checkout`* — is gated on that same output, so a
step gated on any other filter key runs with no repository on disk (PR #476).

Two conventions carried from the sibling suites, both load-bearing:

**Enumerate with `git ls-files`, never a filesystem glob.** `.claude/worktrees/` is
gitignored but present on disk and holds a complete second copy of every file asserted
on here — one per in-flight `/deliver` run. A filesystem walk would read other branches'
checkouts: red locally, green in CI, non-deterministically.

**Every test carries a floor.** A parser that silently reaches a step but not its
values would leave most tests iterating an empty set and passing vacuously — the
*False green* family. `test_discovers_the_expected_cache_steps` and
`test_extracts_the_expected_gate_inventory` pin the exact extracted values, so a
scanner that stops reading block scalars goes red rather than quietly green.
"""

from __future__ import annotations

import re
import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent
WORKFLOW_DIR = ".github/workflows"

EXPRESSION = re.compile(r"\$\{\{\s*(.*?)\s*\}\}")
# Accepts the multi-argument and whitespace-padded forms too — `hashFiles('a', 'b')`
# is valid and hashes the union. A single-argument-only pattern would not match it,
# so `evaluate()` would treat a real hash as an opaque placeholder and the
# degenerate-key test would go red for the wrong reason.
HASHFILES = re.compile(r"^hashFiles\(\s*(.+?)\s*\)$")
HASHFILES_ARG = re.compile(r"'([^']+)'")
OUTPUT_REF = re.compile(r"needs\.changes\.outputs\.([A-Za-z0-9_-]+)")


def _run(*args: str) -> str:
    return subprocess.run(
        args, cwd=ROOT, check=True, capture_output=True, text=True
    ).stdout


def tracked_files() -> frozenset[str]:
    """Every path in the tracked tree, which is what a fresh checkout contains."""
    out = _run("git", "ls-files", "-z")
    return frozenset(p for p in out.split("\0") if p)


def _glob_to_regex(pattern: str) -> re.Pattern[str]:
    """Translate an Actions path glob to a regex.

    Only the constructs these workflows actually use: `**` across directories, `*`
    within a segment, and literal text. Deliberately small — a general globber would
    be more code than the thing under test.
    """
    out = []
    i = 0
    while i < len(pattern):
        if pattern.startswith("**/", i):
            out.append("(?:.*/)?")
            i += 3
        elif pattern.startswith("**", i):
            out.append(".*")
            i += 2
        elif pattern[i] == "*":
            out.append("[^/]*")
            i += 1
        else:
            out.append(re.escape(pattern[i]))
            i += 1
    return re.compile("^" + "".join(out) + "$")


def glob_matches_tracked(pattern: str, tracked: frozenset[str]) -> bool:
    rx = _glob_to_regex(pattern)
    return any(rx.match(path) for path in tracked)


def evaluate(expression: str, tracked: frozenset[str]) -> str:
    """Substitute every `${{ ... }}`, modelling the bug exactly.

    `hashFiles(g)` becomes `H(g)` when `g` matches a tracked file and the EMPTY
    STRING when it does not — which is precisely what GitHub Actions does, and
    precisely how these keys collapsed to constants. Anything else becomes
    `<expr>`, a non-empty placeholder, since `runner.os` and `matrix.name` always
    expand to something.
    """

    def sub(match: re.Match[str]) -> str:
        inner = match.group(1)
        hashed = HASHFILES.match(inner)
        if hashed:
            globs = HASHFILES_ARG.findall(hashed.group(1))
            # `hashFiles` hashes the UNION of its arguments, so it returns '' only
            # when every one of them matches nothing.
            if globs and any(glob_matches_tracked(g, tracked) for g in globs):
                return "H(" + ",".join(globs) + ")"
            return ""
        return f"<{inner}>"

    return EXPRESSION.sub(sub, expression)


def hashfiles_globs(expression: str) -> list[str]:
    globs = []
    for inner in EXPRESSION.findall(expression):
        hashed = HASHFILES.match(inner)
        if hashed:
            globs.extend(HASHFILES_ARG.findall(hashed.group(1)))
    return globs


def workflow_texts() -> dict[str, str]:
    """`{filename: text}` for every tracked workflow.

    Both extensions: GitHub Actions treats `.yaml` and `.yml` identically, so
    matching only one would make a whole workflow invisible to every test here.
    """
    names = sorted(
        p
        for p in tracked_files()
        if p.startswith(WORKFLOW_DIR + "/") and p.endswith((".yml", ".yaml"))
    )
    return {Path(n).name: (ROOT / n).read_text() for n in names}


def _indent(line: str) -> int:
    return len(line) - len(line.lstrip(" "))


def _scalar(lines: list[str], index: int) -> tuple[str, list[str], int]:
    """Read the value at `lines[index]`, inline or as a block/folded scalar.

    Returns `(joined, items, next_index)`. `items` keeps the block's lines separate,
    which is what `restore-keys` and a multi-path `path:` need; `joined` is the
    space-joined form, which is what a folded `>-` condition needs.
    """
    line = lines[index]
    key_indent = _indent(line)
    _, _, inline = line.partition(":")
    inline = inline.strip()
    if inline and inline not in ("|", ">-", ">", "|-"):
        return inline, [inline], index + 1

    items: list[str] = []
    i = index + 1
    while i < len(lines):
        nxt = lines[i]
        if nxt.strip() and _indent(nxt) <= key_indent:
            break
        if nxt.strip():
            items.append(nxt.strip())
        i += 1
    return " ".join(items), items, i


class CacheStep:
    def __init__(self, workflow: str, name: str, paths: list[str], key: str, restore: list[str]):
        self.workflow = workflow
        self.name = name
        self.paths = paths
        self.key = key
        self.restore_keys = restore

    def __repr__(self) -> str:  # pragma: no cover - failure messages only
        return f"CacheStep({self.workflow}, {self.name!r}, key={self.key!r})"


def step_blocks(lines: list[str]) -> list[list[str]]:
    """Every `- ...` list item under a `steps:` key, as a normalised block.

    Blocks rather than a line-by-line state machine, and keyed on the list-item
    dash rather than on `- name:`, because a step is not required to have a name:
    `- uses: actions/cache@v6` is a perfectly ordinary step, and `claude.yml`
    already writes four steps that way. A scanner that only recognised the named
    form skipped such a step *and every field in it* while the inventory
    assertion — which compares only what was found — stayed green.
    """
    blocks: list[list[str]] = []
    steps_indent: int | None = None
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if stripped == "steps:":
            steps_indent = _indent(line)
            i += 1
            continue
        if steps_indent is not None and stripped and _indent(line) <= steps_indent:
            steps_indent = None
        if steps_indent is not None and stripped.startswith("- "):
            item_indent = _indent(line)
            # Normalise `  - name: x` to `    name: x` so the whole block sits at
            # one indentation and `_scalar` can read its block scalars.
            block = [line.replace("- ", "  ", 1)]
            j = i + 1
            while j < len(lines):
                nxt = lines[j]
                if nxt.strip() and _indent(nxt) <= item_indent:
                    break
                block.append(nxt)
                j += 1
            blocks.append(block)
            i = j
            continue
        i += 1
    return blocks


CACHE_USES = re.compile(r"^uses:\s*(actions/cache@\S+)")


def cache_steps() -> list[CacheStep]:
    """Every `actions/cache` step in every tracked workflow, with its values."""
    found: list[CacheStep] = []
    for filename, text in workflow_texts().items():
        for block in step_blocks(text.splitlines()):
            uses = None
            name = None
            for line in block:
                stripped = line.strip()
                match = CACHE_USES.match(stripped)
                if match:
                    uses = match.group(1)
                elif stripped.startswith("name:"):
                    name = stripped.split(":", 1)[1].strip()
            if uses is None:
                continue
            fields: dict[str, object] = {}
            i = 0
            while i < len(block):
                stripped = block[i].strip()
                for field in ("path", "key", "restore-keys"):
                    if stripped.startswith(field + ":"):
                        joined, items, nxt = _scalar(block, i)
                        fields[field] = joined if field == "key" else items
                        i = nxt
                        break
                else:
                    i += 1
            found.append(
                CacheStep(
                    filename,
                    name or uses,
                    list(fields.get("path", [])),  # type: ignore[arg-type]
                    str(fields.get("key", "")),
                    list(fields.get("restore-keys", [])),  # type: ignore[arg-type]
                )
            )
    return found


def ci_lines() -> list[str]:
    return (ROOT / WORKFLOW_DIR / "ci.yml").read_text().splitlines()


def filter_block(text: str) -> dict[str, list[str]]:
    """Parse a `filters: |` block — YAML inside a YAML string, with comments."""
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if line.strip().startswith("filters:"):
            _, items, _ = _scalar(lines, i)
            break
    else:
        return {}

    filters: dict[str, list[str]] = {}
    current = None
    for item in items:
        if item.startswith("#"):
            continue
        if item.endswith(":"):
            current = item[:-1].strip()
            filters[current] = []
        elif item.startswith("- ") and current is not None:
            filters[current].append(item[2:].strip().strip("'\""))
    return filters


def push_paths(text: str) -> list[str]:
    """The `on.push.paths` list, in block *or* flow style.

    Flow style (`paths: ['a', 'b']`) is already used elsewhere in these files —
    `claude.yml` writes `types: [opened, synchronize]` — so a block-only reader
    would return `[]` for such a file and silently check nothing in it.
    """
    lines = text.splitlines()
    for i, line in enumerate(lines):
        stripped = line.strip()
        if not stripped.startswith("paths:"):
            continue
        inline = stripped.split(":", 1)[1].strip()
        if inline.startswith("[") and inline.endswith("]"):
            return [p.strip().strip("'\"") for p in inline[1:-1].split(",") if p.strip()]
        if not inline:
            _, items, _ = _scalar(lines, i)
            return [it[2:].strip().strip("'\"") for it in items if it.startswith("- ")]
    return []


def changes_outputs() -> dict[str, str]:
    lines = ci_lines()
    for i, line in enumerate(lines):
        if line.strip() == "outputs:":
            _, items, _ = _scalar(lines, i)
            return {it.split(":")[0].strip(): it.split(":", 1)[1].strip() for it in items}
    return {}


class Step:
    def __init__(self, job: str, name: str, condition: str, comment: str):
        self.job = job
        self.name = name
        self.condition = condition
        self.comment = comment

    @property
    def outputs(self) -> frozenset[str]:
        return frozenset(OUTPUT_REF.findall(self.condition))


def jobs_with_steps() -> dict[str, dict[str, object]]:
    """`{job: {"runs_on": str, "steps": [Step]}}` for ci.yml.

    Only `if:` and `runs-on:` values are read. Nothing scrapes arbitrary lines, so
    the `run: |` block at the `ci` aggregate that mentions `needs.changes.result`
    cannot be mistaken for a condition.
    """
    lines = ci_lines()
    jobs: dict[str, dict[str, object]] = {}
    job = None
    step_name = None
    pending_comment: list[str] = []
    in_steps = False
    for i, line in enumerate(lines):
        stripped = line.strip()
        if not stripped:
            continue
        if _indent(line) == 2 and stripped.endswith(":") and not stripped.startswith("-"):
            job = stripped[:-1]
            jobs[job] = {"runs_on": "", "steps": []}
            in_steps = False
            pending_comment = []
            continue
        if job is None:
            continue
        if stripped.startswith("#"):
            pending_comment.append(stripped)
            continue
        if _indent(line) == 4 and stripped.startswith("runs-on:"):
            joined, _, _ = _scalar(lines, i)
            jobs[job]["runs_on"] = joined  # type: ignore[index]
            pending_comment = []
            continue
        if _indent(line) == 4 and stripped == "steps:":
            in_steps = True
            pending_comment = []
            continue
        name_match = re.match(r"^- name:\s*(.+)$", stripped)
        if in_steps and name_match:
            step_name = name_match.group(1).strip()
            jobs[job]["steps"].append(  # type: ignore[union-attr]
                Step(job, step_name, "", " ".join(pending_comment))
            )
            pending_comment = []
            continue
        if in_steps and stripped.startswith("if:") and jobs[job]["steps"]:  # type: ignore[index]
            joined, _, _ = _scalar(lines, i)
            jobs[job]["steps"][-1].condition = joined  # type: ignore[index]
            pending_comment = []
            continue
        pending_comment = []
    return jobs


# The exact post-fix inventory. A floor, not a sample: a scanner that finds the
# steps but not their block-scalar values fails HERE rather than leaving every
# other test iterating an empty set and passing vacuously.
EXPECTED_CACHE_STEPS = {
    ("ci.yml", "Cache Swift packages"): {
        "paths": [".build", "~/Library/Developer/Xcode/DerivedData"],
        "key": "${{ runner.os }}-swift-ci-${{ hashFiles('.github/workflows/ci.yml') }}"
        "-${{ hashFiles('Package.swift') }}",
        "restore_keys": ["${{ runner.os }}-swift-ci-${{ hashFiles('.github/workflows/ci.yml') }}-"],
    },
    ("ci.yml", "Cache Xcode DerivedData"): {
        "paths": ["~/Library/Developer/Xcode/DerivedData"],
        "key": "${{ runner.os }}-xcode-${{ matrix.name }}-${{ hashFiles('.github/workflows/ci.yml') }}"
        "-${{ hashFiles('Package.swift') }}",
        "restore_keys": [
            "${{ runner.os }}-xcode-${{ matrix.name }}-${{ hashFiles('.github/workflows/ci.yml') }}-"
        ],
    },
    ("codeql.yml", "Cache Swift packages"): {
        "paths": [".build", "~/Library/Developer/Xcode/DerivedData"],
        "key": "${{ runner.os }}-swift-codeql-${{ hashFiles('.github/workflows/codeql.yml') }}"
        "-${{ hashFiles('Package.swift') }}",
        "restore_keys": [
            "${{ runner.os }}-swift-codeql-${{ hashFiles('.github/workflows/codeql.yml') }}-"
        ],
    },
    ("documentation.yml", "Cache Swift packages"): {
        "paths": [".build", "~/Library/Developer/Xcode/DerivedData"],
        "key": "${{ runner.os }}-docs-${{ hashFiles('.github/workflows/documentation.yml') }}"
        "-${{ hashFiles('Package.swift') }}",
        "restore_keys": [
            "${{ runner.os }}-docs-${{ hashFiles('.github/workflows/documentation.yml') }}-"
        ],
    },
}

EXPECTED_SWIFT_FILTER = [
    "**/*.swift",
    ".swiftformat",
    ".swiftlint.yml",
    ".swift-version",
    "Package.swift",
    "Scripts/**",
    "Makefile",
    ".github/workflows/ci.yml",
    "Tests/TMDbTests/Resources/**",
    "Sources/TMDb/TMDb.docc/**",
    "README.md",
]

EXPECTED_MARKDOWN_FILTER = [
    "README.md",
    "CLAUDE.md",
    ".github/*.md",
    "**/*.docc/**/*.md",
    ".claude/**/*.md",
    "knowledge/**/*.md",
    ".github/workflows/**",
]

EXPECTED_VERSIONCHECK_FILTER = ["README.md", "CHANGELOG.md"]

# Per-workflow, not a global total. A single `assertGreaterEqual(checked, 10)`
# would be satisfied by ci.yml's 16 alone, so the other five files could all
# parse to zero — the exact slack `run-script-tests.py` argues against. These are
# also the only assertion covering claude.yml, integration.yml and
# documentation.yml, which have no `EXPECTED_*_FILTER` pin.
EXPECTED_LITERAL_PATH_COUNTS = {
    "ci.yml": 16,
    "claude.yml": 0,
    "codeql.yml": 0,
    "documentation.yml": 2,
    "integration-failure.yml": 0,
    "integration.yml": 3,
}

EXPECTED_LINT_GATE_OUTPUTS = frozenset({"swift", "markdown", "versioncheck"})


class CacheKeyTests(unittest.TestCase):
    def setUp(self):
        self.tracked = tracked_files()
        self.steps = cache_steps()

    def test_discovers_the_expected_cache_steps(self):
        # Cross-check the parse against raw text before trusting it. `uses:
        # actions/cache@` is a literal the scanner cannot rewrite away, so if the
        # structured walk misses a step — because it was written in a shape the
        # walk does not recognise — the two counts diverge and this fails, rather
        # than every other test in the class quietly iterating a short list.
        raw = sum(t.count("uses: actions/cache@") for t in workflow_texts().values())
        self.assertEqual(
            len(self.steps),
            raw,
            "a cache step is declared in a form the scanner cannot read — every "
            "assertion below would skip it silently",
        )

        found = {(s.workflow, s.name): s for s in self.steps}
        self.assertEqual(
            sorted(found),
            sorted(EXPECTED_CACHE_STEPS),
            "cache-step inventory drifted — add the new step here in the same commit",
        )
        for coord, expected in EXPECTED_CACHE_STEPS.items():
            step = found[coord]
            with self.subTest(step=coord):
                self.assertEqual(step.paths, expected["paths"])
                self.assertEqual(step.key, expected["key"])
                self.assertEqual(step.restore_keys, expected["restore_keys"])

        globs = sorted(g for s in self.steps for g in hashfiles_globs(s.key))
        self.assertEqual(
            globs,
            [
                ".github/workflows/ci.yml",
                ".github/workflows/ci.yml",
                ".github/workflows/codeql.yml",
                ".github/workflows/documentation.yml",
                "Package.swift",
                "Package.swift",
                "Package.swift",
                "Package.swift",
            ],
        )

    def test_every_hashfiles_glob_matches_a_tracked_file(self):
        checked = 0
        for step in self.steps:
            for expression in [step.key, *step.restore_keys]:
                for glob in hashfiles_globs(expression):
                    checked += 1
                    with self.subTest(step=step.name, workflow=step.workflow, glob=glob):
                        self.assertTrue(
                            glob_matches_tracked(glob, self.tracked),
                            f"hashFiles('{glob}') matches no tracked file, so it returns "
                            "the empty string and the key degrades to a constant",
                        )
        self.assertGreaterEqual(checked, 8, "floor: found no hashFiles globs to check")

    def test_no_cache_key_collapses_when_hashfiles_returns_empty(self):
        self.assertTrue(self.steps, "floor: no cache steps discovered")
        for step in self.steps:
            with self.subTest(step=step.name, workflow=step.workflow):
                self.assertIn(
                    "H(",
                    evaluate(step.key, self.tracked),
                    "every hash in this key degrades to '' — the key is a constant",
                )

    def test_every_restore_key_retains_a_hash_and_stays_in_its_own_namespace(self):
        checked = 0
        for step in self.steps:
            key = evaluate(step.key, self.tracked)
            for restore in step.restore_keys:
                checked += 1
                resolved = evaluate(restore, self.tracked)
                with self.subTest(step=step.name, workflow=step.workflow, restore=restore):
                    self.assertIn(
                        "H(",
                        resolved,
                        "a bare restore prefix re-imports the pre-bump cache on the very "
                        "miss the key exists to cause",
                    )
                    self.assertTrue(
                        key.startswith(resolved) and key != resolved,
                        f"{resolved!r} is not a strict prefix of its own key {key!r}",
                    )
        self.assertGreaterEqual(checked, 4, "floor: found no restore-keys to check")

    def test_cache_steps_sharing_a_path_do_not_share_a_namespace(self):
        compared = 0
        for i, a in enumerate(self.steps):
            for b in self.steps[i + 1 :]:
                if not set(a.paths) & set(b.paths):
                    continue
                compared += 1
                a_key, b_key = evaluate(a.key, self.tracked), evaluate(b.key, self.tracked)
                with self.subTest(a=(a.workflow, a.name), b=(b.workflow, b.name)):
                    self.assertNotEqual(a_key, b_key, "two cache steps write the same key")
                    for restore in a.restore_keys:
                        self.assertFalse(
                            b_key.startswith(evaluate(restore, self.tracked)),
                            f"{a.workflow} would restore {b.workflow}'s cache",
                        )
                    for restore in b.restore_keys:
                        self.assertFalse(
                            a_key.startswith(evaluate(restore, self.tracked)),
                            f"{b.workflow} would restore {a.workflow}'s cache",
                        )
        self.assertGreaterEqual(compared, 1, "floor: no path-sharing pairs compared")

    def test_each_cache_key_hashes_the_workflow_file_it_is_declared_in(self):
        self.assertTrue(self.steps, "floor: no cache steps discovered")
        for step in self.steps:
            own = f"{WORKFLOW_DIR}/{step.workflow}"
            with self.subTest(step=step.name, workflow=step.workflow):
                self.assertIn(
                    own,
                    hashfiles_globs(step.key),
                    f"{step.workflow}'s key does not hash {own}, so this workflow's own "
                    "DEVELOPER_DIR pin cannot invalidate its cache",
                )

    def test_no_config_lists_an_untracked_literal_path(self):
        per_file: dict[str, int] = {}
        for filename, text in workflow_texts().items():
            candidates = list(push_paths(text))
            for patterns in filter_block(text).values():
                candidates.extend(patterns)
            literals = [p for p in candidates if "*" not in p]
            per_file[filename] = len(literals)
            for pattern in literals:
                with self.subTest(workflow=filename, pattern=pattern):
                    self.assertIn(
                        pattern,
                        self.tracked,
                        f"{filename} lists '{pattern}', which is not tracked, so the "
                        "entry can never fire",
                    )
        self.assertEqual(
            per_file,
            EXPECTED_LITERAL_PATH_COUNTS,
            "a workflow's paths/filters stopped parsing (or gained entries) — a file "
            "that silently yields 0 is checked by nothing",
        )


class ChangeGateTests(unittest.TestCase):
    def setUp(self):
        self.ci = (ROOT / WORKFLOW_DIR / "ci.yml").read_text()
        self.filters = filter_block(self.ci)
        self.jobs = jobs_with_steps()

    def test_extracts_the_expected_gate_inventory(self):
        lint = self.jobs["lint"]
        referenced = frozenset(
            output for step in lint["steps"] for output in step.outputs  # type: ignore[union-attr]
        )
        self.assertEqual(
            referenced,
            EXPECTED_LINT_GATE_OUTPUTS,
            "the scanner did not read the Lint job's conditions as expected — a folded "
            "`if: >-` it silently skipped would make the subset test below vacuous",
        )
        self.assertGreaterEqual(len(lint["steps"]), 9)  # type: ignore[arg-type]

    def test_every_filter_key_is_exported_as_an_output(self):
        outputs = changes_outputs()
        self.assertTrue(self.filters, "floor: no filters parsed")
        for key in self.filters:
            with self.subTest(filter=key):
                self.assertIn(
                    key,
                    outputs,
                    f"'{key}' is filtered but never exported, so every "
                    f"needs.changes.outputs.{key} is the empty string and its steps "
                    "silently never run",
                )

    def test_every_referenced_output_exists(self):
        outputs = set(changes_outputs())
        referenced = set(OUTPUT_REF.findall(self.ci))
        self.assertTrue(referenced, "floor: no output references found")
        self.assertEqual(
            referenced - outputs,
            set(),
            "a gate references an output the changes job does not export",
        )

    def test_checkout_condition_covers_every_step_condition(self):
        checked = 0
        for name, job in self.jobs.items():
            steps = job["steps"]  # type: ignore[index]
            checkout = next((s for s in steps if s.name == "Checkout"), None)
            if checkout is None or not checkout.condition:
                continue
            checked += 1
            for step in steps:
                with self.subTest(job=name, step=step.name):
                    self.assertTrue(
                        step.outputs <= checkout.outputs,
                        f"{name}/{step.name} is gated on "
                        f"{sorted(step.outputs - checkout.outputs)}, which Checkout is "
                        "not — it would run with no repository on disk",
                    )
        self.assertGreaterEqual(checked, 1, "floor: no gated Checkout found")

    def test_runner_selection_covers_every_step_condition(self):
        checked = 0
        for name, job in self.jobs.items():
            runner_outputs = frozenset(OUTPUT_REF.findall(str(job["runs_on"])))
            if not runner_outputs:
                continue
            checked += 1
            for step in job["steps"]:  # type: ignore[union-attr]
                uncovered = step.outputs - runner_outputs
                if not uncovered:
                    continue
                with self.subTest(job=name, step=step.name):
                    self.assertIn(
                        "# runner-safe:",
                        step.comment,
                        f"{name}/{step.name} can run on a runner selected by "
                        f"{sorted(runner_outputs)} while gated on {sorted(uncovered)}; "
                        "add a '# runner-safe:' comment saying why that is acceptable",
                    )
        self.assertGreaterEqual(checked, 1, "floor: no expression-selected runners found")

    def test_swift_filter_matches_its_exact_declared_inventory(self):
        self.assertEqual(
            self.filters.get("swift"),
            EXPECTED_SWIFT_FILTER,
            "the `swift` filter gates five jobs whose skipped steps still report "
            "success — any change here must be deliberate and diff-visible",
        )

    def test_markdown_filter_matches_its_exact_declared_inventory(self):
        self.assertEqual(self.filters.get("markdown"), EXPECTED_MARKDOWN_FILTER)

    def test_versioncheck_filter_lists_its_consumer_inputs(self):
        self.assertEqual(self.filters.get("versioncheck"), EXPECTED_VERSIONCHECK_FILTER)
        self.assertIn(
            "check-readme-version.py",
            self.ci,
            "name the consumer beside the filter it exists for",
        )


if __name__ == "__main__":
    unittest.main()
