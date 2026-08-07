#!/bin/bash
# PostToolUse formatter for Codex — the mirror of the two PostToolUse hooks in
# .claude/settings.json (.swift → swiftlint --fix + swiftformat; .md/.markdown
# → markdownlint --fix).
#
# Written to be payload-shape independent: the hook-trust gate blocks headless
# payload capture, so the exact stdin schema is unverified until the
# interactive post-merge test (.agents/PORT-STATE.md). Extraction is
# best-effort; when it yields nothing, the fallback formats every file changed
# vs HEAD plus untracked files — correct under any payload shape, at worst a
# little broader than the single edited file.
#
# Contract (mirrors the Claude hooks): NEVER block the tool — always exit 0.

payload=$(cat 2>/dev/null)

files=$(printf '%s' "$payload" | jq -r '
  [
    (.tool_input.file_path // empty),
    (.tool_input.path // empty),
    (.tool_input.changes // [] | .[]? | (.path // empty)),
    (.arguments.file_path // empty),
    (.arguments.path // empty)
  ] | .[]' 2>/dev/null | sort -u)

if [ -z "$files" ]; then
  files=$( (git diff --name-only HEAD; git ls-files --others --exclude-standard) 2>/dev/null | sort -u)
fi

while IFS= read -r f; do
  [ -n "$f" ] && [ -f "$f" ] || continue
  case "$f" in
    *.swift)
      swiftlint --fix "$f" > /dev/null 2>&1
      swiftformat "$f" > /dev/null 2>&1
      ;;
    *.md | *.markdown)
      markdownlint --fix "$f" > /dev/null 2>&1
      ;;
  esac
done <<< "$files"

exit 0
