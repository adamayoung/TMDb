---
name: lint
description: Lint code with swiftlint and swiftformat
---

# Lint code

Run `make lint` from the project root to check code style. It runs **three**
checks, in order: the `lint-witnesses` script
(`Scripts/check-defaulted-witnesses.py`, a cross-symbol rule swiftlint cannot
express), then `swiftlint --strict .`, then `swiftformat --lint .`. A failure in
the first is not a formatting problem and `/format` will not fix it.

Run this directly — it is fast and low-output, so delegating to a subagent would
cost more (subagent overhead) than it saves.

If you see `superfluous_disable_command` errors on files you did not just change,
it is usually a swiftlint version-drift artifact (the pin is swiftlint 0.63.2 /
swiftformat 0.61.1), not a real violation. Run `/format` to auto-fix fixable
violations.
