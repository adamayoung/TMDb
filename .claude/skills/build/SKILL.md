---
name: build
description: Compile the TMDb Swift package for the current platform to check it builds. Use to verify code compiles after changes — delegates the build to a Haiku subagent and returns a concise pass/fail + errors-as-file:line summary, keeping logs out of context. To also compile the test targets, use /build-for-testing.
---

# Build project

Delegate the build to a **Haiku subagent** so the (potentially verbose) build
output stays out of your context. Use the Agent tool with
`subagent_type: general-purpose` and `model: haiku`, give it the prompt below,
then relay its report. Do **not** run the build yourself.

Subagent prompt:

```text
Build the TMDb Swift package and report the result concisely.

- If the xcode-tools MCP is available (running inside Xcode), run
  `mcp__xcode-tools__BuildProject`. On failure, get per-file error detail with
  `mcp__xcode-tools__XcodeRefreshCodeIssuesInFile` on each flagged file.
- Otherwise run `mkdir -p .build && make build > .build/last-build.log 2>&1`,
  check the exit status for pass/fail (the Makefile sets `pipefail`, so a compile
  failure propagates through the xcsift pipe), and summarise from that log file.
  **Trust the exit status, not xcsift's toon summary.** Outside a docs build,
  SwiftPM emits a benign `found N file(s) which are unhandled … *.docc` warning
  (the DocC plugin loads only under `SWIFTCI_DOCC=1`); xcsift lists it under
  `errors[]` with `null,null` coordinates and may print `status: failed`, yet the
  build still **exits 0**. A 0 exit whose only errors are these `.docc`
  unhandled-file entries is a **PASS** — report succeeded and exclude them from
  the error count.

Report back ONLY:
- Status: succeeded or failed
- Error and warning counts
- Each error/warning as `file:line — message` (omit this list if there are none)
- On failure, the full log path `.build/last-build.log` (or, inside Xcode, the
  flagged files so the caller can refresh their diagnostics)

Do not paste raw build logs or successful-compilation output.
```

If the report is unclear on a failure, read the log path it provides (or, inside
Xcode, refresh diagnostics on the flagged files) rather than re-running. After
fixing the issues, re-invoke this skill to re-check (a fresh subagent will
rebuild).
