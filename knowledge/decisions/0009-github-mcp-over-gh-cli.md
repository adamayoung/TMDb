# ADR-0009: Use the GitHub MCP (not the `gh` CLI) in the local skills

- **Status:** Accepted
- **Date:** 2026-06-25
- **Deciders:** Adam Young, Claude

## Context

The project's Claude Code skills (`/pr`, `/watch-pr`, `/review-pr-threads`,
`/fix-pr-checks`, `/fix-integration-failures`, `/diagnose-ci-failure`,
`/diagnose-integration-failure`, and `/deliver`) drove every GitHub interaction by
shelling out to the `gh` CLI and parsing its output. The GitHub **MCP** server
(`mcp__github__*`) exposes the same operations as typed, structured tool calls —
better for an agent than scraping CLI text — so we migrated the skills to it.

The MCP's capability boundary shaped the decision (verified against
`github/github-mcp-server` and the live tool set):

- **Covered:** `create_pull_request`; `pull_request_read` methods `get` /
  `get_diff` / `get_files` / `get_check_runs` / `get_review_comments`;
  `merge_pull_request`; `update_pull_request_branch`;
  `pull_request_review_write` method `resolve_thread`; and the **opt-in** `actions`
  toolset — `actions_list` / `actions_get` / `get_job_logs` (`failed_only`) /
  `actions_run_trigger` (`rerun_failed_jobs`).
- **Not covered → `gh` retained:**
  1. **Blocking CI wait** — there is no equivalent of `gh pr checks --watch` /
     `gh run watch` (the MCP can only poll). Polling burns turns, so the blocking
     wait stays on `gh`.
  2. **Review-thread reply** — `add_reply_to_pull_request_comment` needs a numeric
     REST comment id, but `get_review_comments` returns only GraphQL node ids (a
     type mismatch). The reply stays on `gh api graphql
     addPullRequestReviewThreadReply`, which takes the thread node id we already
     have. (Resolving threads *is* on the MCP.)
  3. **Headless GitHub Actions workflows** (`claude.yml`,
     `integration-failure.yml`) run on CI runners where the **user-scoped** MCP
     isn't mounted, so they stay on `git`/`gh`.

Two facts learned during the work and worth recording:

- The hosted endpoint's `/x/<toolset>` paths are **exclusive**, not additive:
  registering `…/mcp/x/actions` mounts *only* the actions toolset and **drops** the
  default PR/issue toolset. Use `…/mcp/x/all` to get the defaults **plus** actions
  under one `mcp__github__*` namespace.
- The MCP's `pull_request_read get` returns the REST **`mergeable_state`**
  (lowercase `clean`/`blocked`/`behind`/`unstable`/`dirty`/`unknown`/`draft`), not
  `gh`'s GraphQL `mergeStateStatus` (uppercase). The `/watch-pr` merge-readiness
  logic (and the known BLOCKED→CLEAN lag) key off the REST field/values.

## Decision

Migrate the local skills to `mcp__github__*` for all PR / review-thread-read +
resolve / workflow-run operations, keeping `gh` only for the three gaps above. The
MCP server is **user-scoped** and intentionally **not** added to `.mcp.json` —
committing it there would double-register against the per-user server and would
commit a token. Each contributor registers it once:

```bash
claude mcp add -s user --transport http github \
  https://api.githubcopilot.com/mcp/x/all -H "Authorization: Bearer <PAT>"
```

The PAT needs `repo` + fine-grained `actions:write` (the rerun-failed-jobs path is a
write op). The `mcp__github__*` permission lives in the **gitignored**
`.claude/settings.local.json`, so it too is per-machine.

`owner`/`repo` for every call **derive from the `origin` remote** (one source,
fork-safe) rather than being hardcoded:

```bash
read -r OWNER REPO < <(git remote get-url origin \
  | sed -E 's#\.git$##; s#.*[:/]([^/]+)/([^/]+)$#\1 \2#')   # adamayoung TMDb
```

## Consequences

- The skills get typed, structured GitHub access instead of CLI text-scraping, and
  the `actions` toolset gives workflow-run listing, failed-job logs, and
  rerun-failed without `gh`.
- **`gh` remains a prerequisite** (blocking wait, thread reply, headless), so the
  migration narrows — not removes — the `gh` dependency.
- The setup is a **hidden dependency**: nothing in the repo wires up the user-scoped
  server or the gitignored permission, so a fresh machine / new contributor must run
  the `claude mcp add` above and add `mcp__github__*` to their own
  `settings.local.json`, or the skills hard-fail (an expired/read-only PAT fails
  opaquely, with no graceful degradation). This ADR + the *GitHub access* note in
  `CLAUDE.md` are the onboarding breadcrumb.
- All team skills now hinge on **one user's PAT** — a single point of failure the
  `gh`-per-developer model didn't have.
