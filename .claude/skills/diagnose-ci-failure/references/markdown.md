# Lint Markdown job failure (markdownlint)

The **Lint Markdown** job runs in the
`ghcr.io/igorshubovych/markdownlint-cli:v0.48.0` container and lints:

```bash
markdownlint "README.md" "CLAUDE.md" "**/*.docc/**/*.md" ".claude/**/*.md"
```

Four path groups: `README.md`, `CLAUDE.md`, DocC catalog markdown
(`Sources/**/*.docc/**/*.md`), and **every skill and agent file under
`.claude/`** — which in this repo is the most frequently edited of the four, so
a failure here is most often a skill edit, not a README one. `knowledge/**` is
deliberately **not** linted. The job runs only when the `markdown` paths filter
matched one of those, or on `workflow_dispatch`.

Config is `.markdownlintrc`, shared by all four groups. Note **`MD013`
(line-length) and `MD041` (first-line heading) are disabled**, so neither can
be the cause — don't start there.

## Reading the failure

markdownlint emits `file:line[:col] MD0xx/rule-name <message>`. The `MD0xx`
code maps to a rule; common ones in this repo:

- **MD013** line-length — a prose line exceeds the configured limit.
- **MD024** duplicate heading — two headings with the same text in one file.
- **MD031 / MD032** — fenced code blocks / lists need surrounding blank lines.
- **MD040** — fenced code block missing a language (` ``` ` → ` ```swift `/` ```text `).
Configuration is `.markdownlintrc` at the repo root. It **disables** `MD013`
(line length), `MD033` (inline HTML), `MD041` (first-line heading) and `MD060`,
and scopes `MD024` (duplicate heading) to siblings only — so none of those can
be the failure. Read it before assuming a default limit applies.

## Common causes & fixes

- **A skill or agent file under `.claude/`** — the most common cause, since this
  repo edits those constantly. Usually MD040 (fence with no language) or
  MD031/MD032 (missing blank line around a fence or list).
- **A DocC `.md` you edited** (service extension file, `TMDb.md`, `TMDbClient.md`)
  introduced a missing code-fence language or a duplicate sibling heading.
  Fix the flagged `file:line` to satisfy the rule.
- **`README.md` or `CLAUDE.md` edits** — same rules; watch MD040 fence
  languages in examples.

## Reproduce locally

```bash
make lint-markdown
```

(runs the same four `markdownlint` invocations as CI — verified identical to
`.github/workflows/ci.yml`'s `Lint Markdown` step). Fix, re-run until clean.

## Output

**Summary:** Lint Markdown — `MD0xx` at `file:line`.
**Cause:** the rule violation in the changed README / `CLAUDE.md` / DocC /
`.claude/` file.
**Fix:** correct the flagged line; re-run `make lint-markdown`.
