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

Relay its report. Do **not** run the tests yourself.

If the report is unclear on a failure, read the log path it reports
(`.build/last-test.log`) rather than re-running. After fixing the issues,
re-invoke this skill to re-check. To re-check just the previously failing
tests faster, ask the runner for a scoped run instead:

> Run the `test` target scoped to `SuiteName/testName`.
> Package directory: `<your current working directory, absolute>`
