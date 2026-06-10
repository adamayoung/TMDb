---
name: lint
description: Lint code with swiftlint and swiftformat
---

# Lint code

Delegate the lint check to a **Haiku subagent** so the output stays out of your
context. Use the Agent tool with `subagent_type: general-purpose` and
`model: haiku`, give it the prompt below, then relay its report. Do **not** run
lint yourself.

Subagent prompt:

```text
Run `make lint` from the TMDb project root (swiftlint --strict + swiftformat
--lint) and report concisely.

Report back ONLY:
- Status: clean or violations found
- Each violation as `file:line — rule: message` (omit this list if there are
  none)

If you see `superfluous_disable_command` errors on files that were not just
changed, flag it — that is usually a swiftlint version-drift artifact (the pin
is swiftlint 0.63.2 / swiftformat 0.61.1), not a real violation.

Do not paste the full lint output.
```

If the subagent reports violations, fix them in your own context (or run
`/format` for auto-fixable ones), then re-invoke this skill to re-check.
