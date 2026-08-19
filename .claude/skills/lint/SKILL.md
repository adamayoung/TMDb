---
name: lint
description: Lint code with swiftlint and swiftformat
---

# Lint code

Run `make lint` from the project root to check code style. It runs **seven**
checks, in order: five Python scripts under `Scripts/` — `lint-witnesses`
(`check-defaulted-witnesses.py`, protocol conveniences that would witness their
own requirement), `lint-fixtures` (`check-fixtures.py`, JSON fixture hygiene),
`lint-curation` (`check-docc-curation.py`, public methods missing from their
DocC page), `lint-prose` (`check-prose-call-forms.py`, code samples calling a
method that does not exist) and `lint-readme-version`
(`check-readme-version.py`, README's `.package(from:)` vs the newest
`CHANGELOG.md` release) — then `swiftlint --strict .`, then
`swiftformat --lint .`.

Each script enforces something no single-file linter can see, and a failure in
any of them is **not** a formatting problem: `/format` will not fix it.

Run this directly — it is fast and low-output, so delegating to a subagent would
cost more (subagent overhead) than it saves.

If you see `superfluous_disable_command` errors on files you did not just change,
it is usually a swiftlint version-drift artifact (the pin is swiftlint 0.63.2 /
swiftformat 0.61.1), not a real violation. Run `/format` to auto-fix fixable
violations.
