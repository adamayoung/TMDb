---
name: build
description: Compile the TMDb Swift package for the current platform to check it builds. Use to verify code compiles after changes — delegates the build to the tooling-runner agent (Haiku) and returns a concise pass/fail + errors-as-file:line summary, keeping logs out of context. To also compile the test targets, use /build-for-testing.
---

# Build project

Spawn the **`tooling-runner`** agent (Agent tool,
`subagent_type: tooling-runner` — its Haiku pin, command recipes, and
reporting contract live in `.claude/agents/tooling-runner.md`) with the
one-line task:

> Run the `build` target: compile the TMDb Swift package.
> Package directory: `<your current working directory, absolute>`

**Always include that directory line.** The subagent does not reliably inherit
your working directory, and without it a run inside a git worktree silently
builds the main checkout instead (see `.claude/agents/tooling-runner.md`).
Use your actual CWD — run `pwd` if you are not certain of it.

Relay its report. Do **not** run the build yourself — unless the report is
missing or malformed (below), which is the only sanctioned fallback.

If the report is unclear on a failure, read the log path it reports
(`.build/last-build.log`) — or, inside Xcode, refresh diagnostics on the
flagged files — rather than re-running. After fixing the issues, re-invoke
this skill to re-check (a fresh subagent will rebuild).

## If the report is missing or malformed

Judge the runner's report by **shape**, not by tone — the three outcomes are
distinguishable and must be handled differently:

| Report | What it means | What you do |
| --- | --- | --- |
| `Status: refused — …` | A **caller bug** (wrong/missing package directory) | **Surface it as a hard error and fix the call.** Never fall back — the runner is telling you your invocation was unsafe. |
| `Status: passed`/`failed` | A real result | Relay it; act on any failures |
| No report, empty, or missing the `Directory:`/`Status:` lines | The subagent **died** — the run is **void, not failed** | Re-invoke **once**. If it voids again, run `make -C "<the same absolute directory you passed the runner>" build` directly via Bash |

A fallback run is **disclosed in your summary** — say that you fell back and
why. It is never silently treated as an ordinary result.
