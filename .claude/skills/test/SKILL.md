---
name: test
description: Run all TMDb unit tests (Swift Testing, the TMDb test plan). Use after code changes and before a PR to verify unit tests pass — delegates the run to the tooling-runner agent (Haiku) and returns total/passed/failed counts plus each failure as Suite/test with file:line. For the live-API suite, use /integration-test.
---

# Run tests

Spawn the **`tooling-runner`** agent (Agent tool,
`subagent_type: tooling-runner` — its Haiku pin, command recipes, and
reporting contract live in `.claude/agents/tooling-runner.md`) with the
one-line task:

> Run the `test` target: the TMDb unit test suite.
> Package directory: `<your current working directory, absolute>`

**Always include that directory line.** The subagent does not reliably inherit
your working directory, and without it a run inside a git worktree silently
tests the main checkout instead — which reports *"no matching test cases
found"* for suites that exist, or passes without ever seeing your changes (see
`.claude/agents/tooling-runner.md`). Use your actual CWD — run `pwd` if you are
not certain of it.

Relay its report. Do **not** run the tests yourself — unless the report is
missing or malformed (below), which is the only sanctioned fallback.

If the report is unclear on a failure, read the log path it reports
(`.build/last-test.log`) rather than re-running. After fixing the issues,
re-invoke this skill to re-check. To re-check just the previously failing
tests faster, ask the runner for a scoped run instead:

> Run the `test` target scoped to `SuiteName/testName`.
> Package directory: `<your current working directory, absolute>`

## A count is not evidence that *your* new test ran

The full-suite log is an **aggregate** — it names failures only, never the tests
that passed. So `passed_tests: 3105` looks the same whether a test you just
wrote ran, or never compiled into the bundle. The runner is instructed not to
claim otherwise and to report `Names observed: no` for a full run; treat any
per-test claim about a *passing* test in a full-suite report as unfounded, and a
rising total as no evidence about any individual test.

When it matters that a **specific** new test executed — a reproducer for the bug
you are fixing, or a test guarding a branch that had none — ask for the scoped
run above and read the test names in its output. That output *does* name each
test. It costs seconds against an already-built bundle, and it is the difference
between "the suite is green" and "the thing I wrote is doing its job".

## If the report is missing or malformed

Judge the runner's report by **shape**, not by tone — the three outcomes are
distinguishable and must be handled differently:

| Report | What it means | What you do |
| --- | --- | --- |
| `Status: refused — …` | A **caller bug** (wrong/missing package directory) | **Surface it as a hard error and fix the call.** Never fall back — the runner is telling you your invocation was unsafe. |
| `Status: passed`/`failed` | A real result | Relay it; act on any failures |
| No report, empty, or missing the `Directory:`/`Status:` lines | The subagent **died** — the run is **void, not failed** | Re-invoke **once**. If it voids again, run `make -C "<the same absolute directory you passed the runner>" test` directly via Bash |

A fallback run is **disclosed in your summary** — say that you fell back and
why. It is never silently treated as an ordinary result.
