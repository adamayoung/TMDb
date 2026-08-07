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
| `.mcp.json` | `[mcp_servers.*]` in `.codex/config.toml` | PR-A | tmdb / xcode / sosumi mirrored 1:1 (`github` was never in `.mcp.json` — Claude registers it at user scope per ADR-0009; the mirror uses the gh CLI) |
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
- [x] **Project-layer config loads** — **mechanism verified pre-merge** by
  the PR-A code review against Codex CLI 0.147.0 in an isolated scratch
  project using this exact template: the project-layer `config.toml` parsed,
  all three MCP servers registered (2 stdio + 1 streamable-HTTP), sandbox
  network access applied, and all five `[shell_environment_policy.set]` vars
  reached the command environment. After creating the real
  `.codex/config.toml`, a one-line on-repo spot check remains handy:
  `codex exec --ephemeral "Reply with only: the length of TMDB_USERNAME in characters (do not print the value), or 'unset'"`.
- [ ] **tmdb MCP server** —
  `codex exec --ephemeral "Using the tmdb MCP server, fetch movie details for id 550 and reply with only the title"`
  → "Fight Club".
- [ ] **Hook trust + PostToolUse hook fires** — in an interactive `codex`
  session, accept the one-time project-hook trust prompt, then ask it to
  create a deliberately badly-formatted `HookTest.swift`; confirm the on-disk
  file comes back `swiftformat`-normalised; delete the file. **Also verify
  what the trust grant keys on:** after granting, modify
  `.codex/hooks/post-edit-format.sh`'s body and confirm Codex re-prompts —
  if trust keys on the `hooks.json` path alone, a malicious branch could
  swap the script body under an existing grant, which would need mitigating
  (e.g. pinning or re-trust on change).
- [ ] **Refine the provisional hook matcher from observed payloads** — the
  matcher in `.codex/hooks.json` was written blind (see above). Temporarily
  add a logging entry (`"command": "cat > \"$TMPDIR/codex-hook-payload.json\""`,
  matcher `".*"`), edit a scratch file, read the captured payload, correct
  the matcher's tool names and the script's jq paths if they differ, then
  remove the logging entry and the capture file. (Capture into `$TMPDIR`,
  not the repo — an `apply_patch` payload carries file contents, and a
  repo-side capture path would be a tracked file.) The script works under
  any payload shape meanwhile (sweep fallback). Note: `codex doctor` does
  **not** validate `hooks.json` — invalid JSON produces zero diagnostics —
  so this interactive test is the only signal the hook config is live.
