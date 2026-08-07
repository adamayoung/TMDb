# Port inventory 1 — `CLAUDE.md` → `AGENTS.md`

Temporary working artifact for the rule-inventory + adversarial-mapping-review
method (see `.agents/PORT-STATE.md`). Source line numbers refer to `CLAUDE.md`
at the commit this branch forked from (`57a5b651`). Mechanism legend:
**verbatim** (text carried unchanged), **subst** (carried with the standard
substitutions: `/skill` → `$skill`, `CLAUDE.md` → `AGENTS.md`, MCP tool-name
phrasing), **rewrite** (same rule, re-expressed for Codex), **drop** (removed,
reason given), **new** (mirror-only addition).

| # | Rule (gist) | Source | Destination (AGENTS.md section) | Mechanism |
| --- | --- | --- | --- | --- |
| 1 | Purpose line: guidance for the agent CLI | 1–4 | Title/intro | rewrite (Codex) |
| 2 | Platforms; Windows deliberately not claimed (PR #374) | 6–11 | Project Overview | verbatim |
| 3 | `knowledge/` read on demand; this file stays imperative | 13–17 | Knowledge Base | subst |
| 4 | Knowledge sub-file index (decisions/gotchas/api-notes/next-major/skill-improvement-log) | 19–29 | Knowledge Base | verbatim |
| 5 | Skim before non-trivial work; record durable learnings; `/capture-knowledge` runs pre-PR in `/deliver`; ADR for non-obvious decisions | 31–34 | Knowledge Base | subst |
| 6 | Architecture: service design, 28 services, TMDbIntelligence split, key files | 36–101 | Architecture | verbatim |
| 7 | Networking decorator chain + ErrorMappingAPIClient | 103–124 | Architecture | verbatim |
| 8 | Language Model Tools (Apple-only) | 126–141 | Architecture | verbatim |
| 9 | Test organization + shared fixtures target rules | 143–157 | Architecture | verbatim |
| 10 | Adding a test target: names hardcoded in FOUR places; consequences of missing each | 159–169 | Architecture | verbatim |
| 11 | OpenAPI spec URL + uses | 171–179 | Understanding the TMDb API | verbatim |
| 12 | ALWAYS use the tmdb MCP server to query the live API (3 uses) | 181–189 | Understanding the TMDb API | subst (server registered in `.codex/config.toml`; tool-name phrasing) |
| 13 | 6-step workflow for new endpoints | 191–198 | Understanding the TMDb API | subst (step 2 MCP phrasing) |
| 14 | Skill-driven workflow; plan first; invoking `/deliver` IS plan approval; autonomous to ready-to-merge; auto-scales; triages unrelated red CI; retro pre-PR | 200–214 | Development Workflow | subst + rewrite (`/plan` → agree a plan in conversation; pipeline arrow with `$names`) |
| 15 | Key-skills list (8 bullets incl. watch-pr delegating unrelated integration failures) | 216–231 | Development Workflow | subst |
| 16 | Self-healing integration: weekly cron watched by integration-failure.yml; PR-for-review never auto-merge; headless = targeted suite + git/gh | 233–239 | Development Workflow | subst + note (GitHub Action runs the **Claude** toolchain) |
| 17 | One shared review spec (.github/CODE_REVIEW.md); reviewers run only on reviewable code (Swift + committed orchestration scripts); three subagents with model tiers | 241–248 | Development Workflow | subst + rewrite (scripts surface = `.agents/skills/*/scripts/`; tiers named cheap/mid/flagship, defined in `.codex/agents/`) |
| 18 | Prefer `$build`/`$build-for-testing`/`$test`/`$integration-test` (spawn tooling-runner); log to `.build/last-*.log`; report contract: `Directory:`+`Status:` always; `refused` = caller bug, never fall back; missing lines = void → re-invoke once → `make -C <dir>` fallback, disclosed | 250–264 | Build and Test Tooling | subst — **contract text word-for-word** |
| 19 | `/lint` + `/format` run make directly; `make ci` direct before a PR | 266–267 | Build and Test Tooling | subst |
| 20 | Inside-Xcode path (`mcp__xcode-tools__*`, test-plan selection) | 269–277 | — | **drop** (Codex has no Xcode-native host). Replacement one-liner: xcode MCP stays registered as optional; xcsift/test-plan detail pointer to `knowledge/gotchas.md` **kept** |
| 21 | SwiftPM scratch dir; sequential builds within a worktree; SCRATCH_PATH per agent in separate worktrees | 279–290 | Build and Test Tooling | verbatim |
| 22 | Shell env: no `source ~/.zshrc`; 5 env vars (v4 pair optional → suites skip); Homebrew tools on PATH | 292–304 | Build and Test Tooling | rewrite (env from `[shell_environment_policy]` in gitignored `.codex/config.toml`, template `config.example.toml`) |
| 23 | Makefile is the command set; `make ci` composition; single-test filter; no `make test-ios` — simulator tests from Xcode | 306–315 | Common Commands | subst |
| 24 | Code style rules (6 bullets) + pinned tool versions + `superfluous_disable_command` drift diagnosis | 317–335 | Code Style | verbatim |
| 25 | Format-on-edit hooks; consequences: on-disk differs, re-read before dependent edit, hooks can't fix real errors, MD013 caveat | 337–350 | Code Style | rewrite (mechanism = `.codex/hooks.json` + `post-edit-format.sh`) — **consequence text word-for-word** |
| 26 | SourceKit new-file diagnostics lag; trust `make build` | 352–357 | Code Style | verbatim |
| 27 | TDD via canon-tdd; test list; failing test (unit AND integration) before production code; reproducing test for bugs | 359–366 | Testing | subst |
| 28 | Always run both suites; why unit-only is insufficient | 368–377 | Testing | verbatim |
| 29 | Coverage matrix (features/bugfixes/refactors/model changes) | 379–384 | Testing | verbatim |
| 30 | Fixture completeness: every decoder path; all N appended properties; paired without-data test; never assume branches | 386–398 | Testing | verbatim |
| 31 | Never force-unwrap in tests; `#require()` example | 400–410 | Testing | verbatim |
| 32 | New-service structural pattern (4 steps; TMDbFactory vends only shared plumbing) | 412–428 | Adding New Features | subst |
| 33 | DocC required on every public declaration; warnings-as-errors; conventions live in `$document-swift`; keep docc+README+`///` in sync | 430–438 | Documentation | subst |
| 34 | Completion checklist; `make ci` mandatory gate — no exceptions; self-review duties | 440–452 | Completion Checklist | subst |
| 35 | CRITICAL never edit `main`; verify branch; prefix conventions | 454–473 | Branching | verbatim |
| 36 | `$deliver` runs in its own worktree, branched off origin/main, torn down on merge | 475–480 | Branching | rewrite (mirror homes: `.worktrees/`, `.agents/skills/deliver/SKILL.md`) |
| 37 | `/pr` steps (commit → rebase → make ci → review → push → open); gitmoji + body template live in the skill | 482–487 | Creating Pull Requests | subst (open via **gh**) |
| 38 | GitHub access route + rationale ADR | 489–493 | Creating Pull Requests | rewrite (gh CLI primary; ADR-0009 scoped to Claude toolchain; ADR-0018 forthcoming) |
| 39 | `make ci` must pass before pushing/PR — no exceptions (repeated) | 495 | Creating Pull Requests | verbatim (deliberate duplication of #34 — keep both) |
| 40 | Mirror status: phased rollout fallback (`$skill` not yet installed → use the raw command it wraps); drift procedure pointer (`$check-drift`, PORT-STATE) | — | Codex mirror & drift (new final section) | new |

## Mapping-review findings

Independent adversarial mapping review (code-reviewer subagent, original
`CLAUDE.md` as ground truth) returned 2 High / 3 Medium / 3 Low / 1
observation. Resolutions:

1. **High — `.codex/` assets asserted but absent** → resolved by construction:
   the review ran mid-implementation; the `.codex/` layer lands later in this
   same PR (confirmed before merge by rubric AC-4/AC-5).
2. **High — "or the Xcode MCP" prohibition dropped while the MCP stays
   registered** → fixed: prohibition restored in *Prefer the Project Skills*;
   "for occasional use, not a route to call instead of the skills" added to
   the registration note. (Corrects this inventory's rows 18/20, which
   claimed full coverage.)
3. **Medium — skill→`make`-target mapping lost** → fixed: `(make build / make
   test / make integration-test)` restored to the terminal-path paragraph.
4. **Medium — "(not `/pr`)" dropped from the headless-integration contract**
   → fixed: restored, slash form kept (Claude-toolchain context).
5. **Medium — phased-rollout fallback undefined for skills wrapping no raw
   command** → fixed: "do its work inline against CODE_REVIEW.md /
   knowledge/ — never skip it" appended to the mirror section.
6. **Low — `canon-tdd` conversion inconsistent** → fixed: `$canon-tdd` at
   all **three** sites (the PR-A code review caught a third occurrence in the
   key-skills list that the first fix missed).
7. **Low — hook singular/plural mismatch** → fixed: "The hook can't fix…".
8. **Low — README pointer lost its section name; over-claimed name parity**
   → fixed: section named; `$security-review` excepted as mirror-local.
9. **Observation — `.github/CODE_REVIEW.md` capability-scope bullet names
   Claude-flavoured tools** → recorded in PORT-STATE's deliberate
   divergences; generalising the shared spec is deferred to a later mirror
   PR.

Row-15 bullet count corrected (8, not 9). No waivers — every finding fixed
or resolved-by-construction.
