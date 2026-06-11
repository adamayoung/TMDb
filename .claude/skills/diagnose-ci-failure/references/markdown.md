# Lint Markdown job failure (markdownlint)

The **Lint Markdown** job runs in the
`ghcr.io/igorshubovych/markdownlint-cli:v0.41.0` container and lints:

```
markdownlint "README.md" "**/*.docc/**/*.md"
```

So only `README.md` and DocC catalog markdown (`Sources/TMDb/TMDb.docc/**/*.md`)
are checked — not arbitrary repo markdown. It only runs when the `markdown`
paths filter matched (README or a DocC `.md` changed), or on
`workflow_dispatch`.

## Reading the failure

markdownlint emits `file:line[:col] MD0xx/rule-name <message>`. The `MD0xx`
code maps to a rule; common ones in this repo:

- **MD013** line-length — a prose line exceeds the configured limit.
- **MD024** duplicate heading — two headings with the same text in one file.
- **MD031 / MD032** — fenced code blocks / lists need surrounding blank lines.
- **MD040** — fenced code block missing a language (` ``` ` → ` ```swift `/` ```text `).
- **MD041** — first line in the file should be a top-level heading.

Configuration, if present, lives in a `.markdownlint*` file at the repo root —
check it before assuming the default limits.

## Common causes & fixes

- **A DocC `.md` you edited** (service extension file, `TMDb.md`, `TMDbClient.md`)
  introduced a long line, a missing code-fence language, or a duplicate heading.
  Fix the flagged `file:line` to satisfy the rule.
- **README edits** — same rules; watch MD013 line length and MD040 fence
  languages in examples.

## Reproduce locally

```
make lint-markdown
```

(runs the same `markdownlint` invocations as CI — `markdownlint "README.md"` and
`markdownlint "**/*.docc/**/*.md"`). Fix, re-run until clean.

## Output

**Summary:** Lint Markdown — `MD0xx` at `file:line`.
**Cause:** the rule violation in the changed README/DocC file.
**Fix:** correct the flagged line; re-run `make lint-markdown`.
