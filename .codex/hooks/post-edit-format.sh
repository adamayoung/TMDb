#!/bin/bash
# PostToolUse formatter for Codex — the mirror of the two PostToolUse hooks in
# .claude/settings.json (.swift → swiftlint --fix + swiftformat; .md/.markdown
# → markdownlint --fix).
#
# Written to be payload-shape independent: the hook-trust gate blocks headless
# payload capture, so the exact stdin schema is unverified until the
# interactive post-merge test (.agents/PORT-STATE.md). Extraction is
# best-effort; when it yields nothing, the fallback formats files changed vs
# HEAD plus untracked files, bounded to ones touched in the last two minutes —
# correct under any payload shape, at worst a little broader than the single
# edited file.
#
# Contract (mirrors the Claude hooks): NEVER block the tool — always exit 0.

payload=""
if [ ! -t 0 ]; then
  payload=$(cat 2>/dev/null)
fi

# Repo-root anchor: `git diff --name-only` emits root-relative paths wherever
# the hook's cwd is, and swiftlint/markdownlint resolve their configs from cwd.
root=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$root" ]; then
  cd "$root" 2>/dev/null || exit 0
fi

files=$(printf '%s' "$payload" | jq -r '
  [
    (.tool_input.file_path // empty),
    (.tool_input.path // empty),
    (.tool_input.changes // [] | .[]? | (.path // empty)),
    (.arguments.file_path // empty),
    (.arguments.path // empty)
  ] | .[]' 2>/dev/null | sort -u)

swept=0
if [ -z "$files" ]; then
  swept=1
  files=$( (git diff --name-only HEAD; git ls-files --others --exclude-standard) 2>/dev/null | sort -u)
fi

now=$(date +%s)
while IFS= read -r f; do
  [ -n "$f" ] && [ -f "$f" ] || continue
  if [ "$swept" = 1 ]; then
    # Bound the fallback sweep: only files modified in the last 120s (the
    # edit that triggered this hook), not the whole dirty tree. Fail open —
    # an unreadable mtime still formats.
    m=$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null)
    if [ -n "$m" ] && [ $((now - m)) -gt 120 ]; then
      continue
    fi
  fi
  case "$f" in
    -*) f="./$f" ;;
  esac
  # Containment: never format outside the repo (payload shape is unverified,
  # so extracted paths are untrusted until the interactive capture confirms
  # them; absolute paths must live under the repo root, and ../ never enters).
  case "$f" in
    /*)
      case "$f" in
        "$root"/*) ;;
        *) continue ;;
      esac
      ;;
    ../*) continue ;;
  esac
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
