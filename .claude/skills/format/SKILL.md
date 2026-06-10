---
name: format
description: Format code with swiftlint and swiftformat
---

# Format code

Run `make format` from the project root to fix code style issues (swiftlint --fix
+ swiftformat).

Run this directly — it is fast and low-output, so delegating to a subagent would
cost more (subagent overhead) than it saves.
