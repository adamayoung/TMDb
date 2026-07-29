---
name: integration-test
description: Run the TMDb integration tests against the live TMDb API (the Integration test plan; requires TMDB_API_KEY/USERNAME/PASSWORD). Use before a PR, or after model/fixture changes, to validate against real API responses — delegates to the tooling-runner agent (Haiku) and returns counts + failures, distinguishing genuine failures from transient live-API/env issues. For mocked unit tests, use /test.
---

# Run integration tests

Spawn the **`tooling-runner`** agent (Agent tool,
`subagent_type: tooling-runner` — its Haiku pin, command recipes, and
reporting contract live in `.claude/agents/tooling-runner.md`) with the
one-line task:

> Run the `integration-test` target: the TMDb live-API integration suite.
> Package directory: `<your current working directory, absolute>`

**Always include that directory line.** The subagent does not reliably inherit
your working directory, and without it a run inside a git worktree silently
tests the main checkout instead (see `.claude/agents/tooling-runner.md`).
Use your actual CWD — run `pwd` if you are not certain of it.

Relay its report — it distinguishes genuine assertion failures from
transient live-API issues (429/timeout/network) and env/precondition
failures. Do **not** run the tests yourself — unless the report is missing or
malformed (below), which is the only sanctioned fallback.

If the report is unclear on a failure, read the log path it reports
(`.build/last-integration-test.log`) rather than re-running. After fixing
the issues, re-invoke this skill to re-check. To attribute a failure
(live-API/backend drift vs a regression in your change), use
`/diagnose-integration-failure`.

## If the report is missing or malformed

Judge the runner's report by **shape**, not by tone — the three outcomes are
distinguishable and must be handled differently:

| Report | What it means | What you do |
| --- | --- | --- |
| `Status: refused — …` | A **caller bug** (wrong/missing package directory) | **Surface it as a hard error and fix the call.** Never fall back — the runner is telling you your invocation was unsafe. |
| `Status: passed`/`failed` | A real result | Relay it; act on any failures |
| No report, empty, or missing the `Directory:`/`Status:` lines | The subagent **died** — the run is **void, not failed** | Re-invoke **once**. If it voids again, run `make -C "<the same absolute directory you passed the runner>" integration-test` directly via Bash |

A fallback run is **disclosed in your summary** — say that you fell back and
why. It is never silently treated as an ordinary result.
