---
name: pr
description: Create a pull request
---

# Create a pull request

I'll create a pull request for the current branch by following these steps. If any steps fail, stop.

**Mode** — check the arguments passed to this skill (shown at the end). If they
include `reviewed` (or `skip-review`), an upstream step already ran the
`code-reviewer` and fixed its findings (e.g. `/deliver`'s code-review phase), so
**skip steps 5–7** to avoid reviewing identical code twice. Otherwise (standalone
`/pr`), run the internal review as normal.

**Also skip steps 5–7 when the branch changes no Swift** — code review is for
Swift, so a docs-only / config-only PR needs none:

```bash
git diff --name-only origin/main...HEAD | grep -qE '\.swift$' || echo "no-swift → skip review"
```

1. Run `/format` to format code
2. **Commit all outstanding work.** Run `git status`. If the working tree has **any** uncommitted or unstaged changes (the feature work, plus the formatting from step 1), stage and commit them — the PR reflects **committed history only**, so anything left uncommitted will be **missing from the PR**. First **verify no secrets, `.env`, or build artifacts** are included (per CLAUDE.md — `.env` must stay gitignored; check `git status` before `git add`). Use a descriptive gitmoji message (or several logical commits if the work spans concerns); formatting-only changes can use "🎨 apply code formatting". If the tree is already clean (e.g. work was committed during `/deliver`), this is a no-op.
3. **Rebase onto the latest `origin/main`.** Fetch the remote and rebase the feature branch directly onto `origin/main` — do this **before** `make ci` so the gate (and the eventual PR) reflects the real merge result, not stale code:

    ```bash
    git fetch origin
    git rebase origin/main
    ```

    - **Rebase onto `origin/main`, not local `main`** — this is **worktree-safe**. A `/deliver` runs inside a git worktree, and `git checkout main` there fails (`fatal: 'main' is already used by worktree …`) whenever the main checkout is on `main`; rebasing onto `origin/main` avoids checking `main` out at all and uses the true remote base directly.
    - If `git rebase` reports conflicts, **stop**, resolve them, then continue. Never skip or force past a conflict you don't understand.
    - The rebase rewrites the branch tip, so a branch that was **already pushed** will need `git push --force-with-lease` at the push step below.
    - Already branched off an up-to-date `origin/main` with nothing to replay → this is a fast no-op.
4. Run the pre-PR gate — **MANDATORY; it must pass before going further.** Run it directly (do not delegate). If it fails, stop and fix — **commit the fixes** — then re-run; never open a PR on a red gate. Scale the gate to the diff:
    - **Default — full `make ci`.** The gate CLAUDE.md requires before any PR: lint, markdown lint, unit tests, integration tests, the release build, and the docs build. Use this whenever **any** code or build-affecting file changed.
    - **Docs/config-only fast gate.** When the diff touches **no build- or test-affecting files** — i.e. no `*.swift` **and** none of `Makefile`, `Package.swift`, `Package.resolved`, `*.xctestplan`, or `.github/workflows/**` — the test/release-build legs of `make ci` have nothing to exercise. Run only the meaningful checks instead: `make lint && make lint-markdown && make build-docs` (drop `build-docs` if no `*.docc/**` changed). Detect this with:

        ```bash
        git diff --name-only origin/main...HEAD \
          | grep -qE '\.swift$|^Makefile$|^Package\.(swift|resolved)$|\.xctestplan$|^\.github/workflows/' \
          && echo "code/build touched → full make ci" \
          || echo "docs/config-only → fast gate"
        ```

        The PR's own CI still runs the full matrix regardless, so this only trims the **local** gate; it never lowers what actually guards `main`. When in doubt, run full `make ci`.
    - **Re-lint new Swift files without the cache.** `make ci`'s lint leg is `swiftlint --strict .` (Makefile), and SwiftLint **caches results** (`~/Library/Caches/SwiftLint`). On **newly-added** `.swift` files this has been seen to report a **false green** locally — passing `file_length` / `type_body_length` that the PR's CI `Lint` job (a clean checkout, no cache) then fails on. So **when the diff adds any new `.swift` file** (`git diff --name-only --diff-filter=A origin/main...HEAD | grep -q '\.swift$'`), run a cache-bypassing lint before trusting the gate:

        ```bash
        swiftlint lint --strict --no-cache .
        ```

        Fix anything it flags (oversized files: split, or add a `// swiftlint:disable` directive matching the `AccountService+Pagination.swift` precedent) and re-run. This catches file-size violations locally instead of on a CI round-trip.
5. *(skip in `reviewed` mode or when no Swift changed)* Spawn the `code-reviewer` agent to perform a code review of all changes (pass the git diff output as context)
6. *(skip in `reviewed` mode or when no Swift changed)* Summarize the code review findings:
    - List any critical or high-severity issues that should be addressed
    - List any medium-severity suggestions for improvement
    - Note any low-severity or stylistic recommendations
7. *(skip in `reviewed` mode or when no Swift changed)* If there are critical/high-severity issues:
    - Recommend specific changes needed
    - Ask user for confirmation before proceeding (fix issues or continue anyway)
    - If user wants to fix issues, stop and let them address the feedback
8. **Ensure a clean working tree before pushing.** Re-run `git status`; commit anything still outstanding (e.g. review fixes from steps 5–7, or `make ci` fixes) so the push includes **everything**. The tree must be clean before proceeding. Then run `git diff origin/main...HEAD` to understand all changes going into the PR.
9. Analyze the commits and changes to generate an appropriate title and summary
10. Push the current branch to remote (`git push -u origin <branch>` if not yet pushed; otherwise `git push` — use `git push --force-with-lease` if you rebased in step 3)
11. Create a PR with the **GitHub MCP** — `mcp__github__create_pull_request` (owner/repo from the `origin` remote, `base: main`, `head: <branch>`, plus `title`/`body`). The branch must already be pushed (step 10). If the call fails with **401/403** (PAT expired or missing scope), fall back to `gh pr create` with the same title/body.

    **Title** — MUST start with a [gitmoji](https://gitmoji.dev) prefix matching the change:

    | Emoji | Code | Use for |
    |-------|------|---------|
    | ✨ | `:sparkles:` | New features |
    | 🐛 | `:bug:` | Bug fixes |
    | 📝 | `:memo:` | Documentation updates |
    | ♻️ | `:recycle:` | Refactoring |
    | ✅ | `:white_check_mark:` | Adding/updating tests |
    | 🔧 | `:wrench:` | Configuration changes |
    | ⚡️ | `:zap:` | Performance improvements |
    | 🎨 | `:art:` | Code style/formatting |

    Example: `✨ Add createdBy property to TVSeries`.

    **Body** — fill this skeleton, keeping only the sections that apply, and end with the attribution line exactly as shown:

    ```markdown
    ## Summary

    [Brief description of what this PR does and why]

    ## Changes

    **New Model/Feature/Component:**
    - ✨ [Description]

    **Existing Files:**
    - 📝 [Description]

    **Tests:**
    - ✅ [Description of test coverage]

    **Documentation:**
    - 📚 [Description]

    ## Benefits

    - **[Benefit Category]**: [Description]

    🤖 Generated with [Claude Code](https://claude.com/claude-code)
    ```

$ARGUMENTS
