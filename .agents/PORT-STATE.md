# Codex mirror — port state

This file is the durable record of the **Codex CLI mirror** of this repo's
Claude Code configuration: what has been ported, from which `.claude`-tree
commit, and which divergences are deliberate. It is the memory that the
`$check-drift` skill (arrives with the final port PR) reads before judging
whether the two setups have drifted apart.

## Synced-commit marker

```text
synced-commit: (not yet set — set when the full port lands; until then, each
PR below records the source commit it ported from)
```

## Port method

Every normative document is ported with the **rule-inventory + adversarial
mapping review** method:

1. Extract every load-bearing rule from the source into an inventory in
   [`port/`](port/) (one row per rule: gist, source `file:line`, destination,
   mechanism — mechanical / prose / dropped-with-reason).
2. Write the Codex-native copy.
3. An **independent** reviewer diffs the new copy against the **original**
   source text (not the inventory) hunting dropped or weakened rules; every
   finding is fixed or explicitly waived in the inventory.

The `port/` inventories are temporary working artifacts — they are deleted
when the final port PR lands (git history archives them); this file keeps the
durable residue (the file map and the deliberate divergences).

## File map (source → mirror)

| Source | Mirror | Ported in | Treatment |
| --- | --- | --- | --- |
| `CLAUDE.md` | `AGENTS.md` | PR-A | Section-by-section port; `$skill` names; Xcode-native section dropped; PR section re-based on `gh` |
| `.claude/settings.json` (PostToolUse hooks) | `.codex/hooks.json` + `.codex/hooks/post-edit-format.sh` | PR-A | Same events; single script handles `.swift` + `.md`; always exits 0 |
| `.claude/settings.local.json` (`env` block) | `.codex/config.toml` (gitignored; template: `.codex/config.example.toml`) | PR-A | `[shell_environment_policy.set]`; never committed |
| `.mcp.json` | `[mcp_servers.*]` in `.codex/config.toml` | PR-A | tmdb / xcode / sosumi mirrored; `github` deliberately absent (gh CLI instead) |
| `.claude/agents/*.md` | `.codex/agents/*.toml` | PR-B (planned) | — |
| `.claude/skills/*` | `.agents/skills/*` | PR-B/C (planned) | — |
| `.claude/workflows/deliver-panel.js` | `.agents/skills/deliver/scripts/deliver-panel.sh` | PR-C (planned) | Deterministic script; tally arithmetic preserved |
| `.github/CODE_REVIEW.md` | shared as-is (no copy) | — | Tool-agnostic; both reviewers read the same file |
| `knowledge/` | shared as-is (no copy) | — | Referenced from `AGENTS.md` exactly as from `CLAUDE.md` |

## Deliberate divergences (a drift check must NOT flag these)

- **GitHub access:** the mirror uses the `gh` CLI everywhere the Claude setup
  uses the GitHub MCP (ADR-0009 is scoped to the Claude toolchain; the mirror
  decision will be recorded as ADR-0018 in the final port PR).
- **No Xcode-native path:** Codex has no Xcode host, so the mirror keeps only
  the terminal/`make` path; the `xcode` MCP server remains registered as
  optional.
- **Worktree + run-file homes:** Codex deliveries will use `.worktrees/` and
  `.git/deliver-codex/` (Claude keeps `.claude/worktrees/` and
  `.git/deliver/`) so the two GC sweeps can never touch each other's state.
- **No `ScheduleWakeup` / background-task harness:** deferred re-checks
  become blocking `gh pr checks --watch` / `gh run watch` or bounded loops.
- **`mergeStateStatus` casing:** `gh pr view --json mergeStateStatus` returns
  the GraphQL UPPERCASE enum (`CLEAN`/`BLOCKED`/`BEHIND`), not the GitHub
  MCP's lowercase `mergeable_state` — ported logic is re-keyed, not drifted.
- **`$security-review` is a local skill** in the mirror (Claude uses a
  built-in `/security-review`).
- **`.github/CODE_REVIEW.md` reads Claude-flavoured in one bullet:** its
  capability-scope section names `/build`, `/test`, `/integration-test` and
  `mcp__tmdb__*` as the local reviewer's tools. The mirror reads those
  through as their `$`-twins / the `tmdb` MCP server; generalising the shared
  spec's wording is deferred to a later mirror PR.

## Deferred post-merge verification (PR-A)

What PR-A's in-worktree probe **did** establish: `codex exec` runs fine
inside a `.claude/worktrees/` worktree (trust extends to subpaths of the
trusted project root), and the agent edits files via `apply_patch`. What it
could **not** establish: project-layer hooks are additionally gated by a
persisted **hook-trust store** that a headless run cannot satisfy
(`--dangerously-bypass-hook-trust` exists but was out of bounds for the
autonomous run), so no hook fired and no payload was captured. The
`post-edit-format.sh` script is therefore payload-shape independent (git-diff
sweep fallback), and the `hooks.json` matcher is **provisional** until the
interactive test below observes real payloads. Run each item from the main
checkout once PR-A merges; check them off here (or note the failure) in the
next mirror PR:

- [x] **AGENTS.md read-back** —
  `codex exec --ephemeral "State this repo's branching rule and the mandatory pre-PR gate, citing the file you read them from"`
  → must answer never-edit-`main` + `make ci`, from `AGENTS.md`. **Passed
  pre-merge** (run from the PR-A worktree, 2026-08-07: answered both rules,
  cited `AGENTS.md`).
- [ ] **Project-layer config loads** — with `.codex/config.toml` created from
  the template: `codex exec --ephemeral "Reply with only: the value of TMDB_USERNAME's length in characters (do not print the value), or 'unset'"`
  → non-`unset` proves `[shell_environment_policy]` merged from the project
  layer.
- [ ] **tmdb MCP server** —
  `codex exec --ephemeral "Using the tmdb MCP server, fetch movie details for id 550 and reply with only the title"`
  → "Fight Club".
- [ ] **Hook trust + PostToolUse hook fires** — in an interactive `codex`
  session, accept the one-time project-hook trust prompt, then ask it to
  create a deliberately badly-formatted `HookTest.swift`; confirm the on-disk
  file comes back `swiftformat`-normalised; delete the file.
- [ ] **Refine the provisional hook matcher from observed payloads** — the
  matcher in `.codex/hooks.json` was written blind (see above). Temporarily
  add a logging entry (`"command": "cat > .codex/hooks/last-payload.json"`,
  matcher `".*"`), edit a scratch file, read the captured payload, correct
  the matcher's tool names and the script's jq paths if they differ, then
  remove the logging entry and the capture file. The script works under any
  payload shape meanwhile (sweep fallback).
