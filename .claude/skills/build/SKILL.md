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

Relay its report. Do **not** run the build yourself.

If the report is unclear on a failure, read the log path it reports
(`.build/last-build.log`) — or, inside Xcode, refresh diagnostics on the
flagged files — rather than re-running. After fixing the issues, re-invoke
this skill to re-check (a fresh subagent will rebuild).
