---
name: format
description: Format code with swiftlint and swiftformat
---

# Format code

Delegate formatting to a **Haiku subagent** so the output stays out of your
context. Use the Agent tool with `subagent_type: general-purpose` and
`model: haiku`, give it the prompt below, then relay its report. The subagent
runs in your working directory, so its formatting edits persist for you. Do
**not** run format yourself.

Subagent prompt:

```text
Run `make format` from the TMDb project root (swiftlint --fix + swiftformat),
then run `git status --short` to see what changed. Report concisely.

Report back ONLY:
- Status: files reformatted or already clean
- The list of modified files (from `git status --short`)

Do not paste file diffs or the full formatter output.
```
