---
name: build
description: Compile the TMDb Swift package for the current platform to check it builds. Use to verify code compiles after changes — delegates the build to a Haiku subagent and returns a concise pass/fail + errors-as-file:line summary, keeping logs out of context. To also compile the test targets, use /build-for-testing.
---

# Build project

Spawn the **`swift-builder`** agent (Agent tool, `subagent_type: swift-builder`)
and relay its report. The agent is Haiku-pinned and keeps the verbose build
output out of your context. Do **not** run the build yourself.

If the report is unclear on a failure, read the log path it provides (or, inside
Xcode, refresh diagnostics on the flagged files) rather than re-running. After
fixing the issues, re-invoke this skill to re-check (a fresh agent will
rebuild).
