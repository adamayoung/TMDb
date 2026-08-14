# Filing a GitHub Issue

The single source of truth for **how work gets filed** in this repo. Skills that
discover work they are not going to do — `/review-changes`, `/deliver`,
`/capture-knowledge`, `/review-knowledge`, `/review-pr-threads` — point here
rather than restating any of it. `/triage-issues` consumes what this produces.

If this file and a skill ever disagree, **this file is right**.

## When to file

File when all three hold:

1. The work is **real** — a defect, a gap, or a decision that has to be made.
2. It is **out of scope for what you are doing now** — in scope means fix it,
   not file it.
3. It will be **lost otherwise** — it is not already captured in `knowledge/`,
   an ADR, `next-major.md`, or an open issue.

Do **not** file: anything you just fixed, a restatement of an existing
`knowledge/` entry, a style preference with no defect behind it, or a "consider
maybe someday" with no failure scenario. A tracker of speculative items is worse
than no tracker — it makes the real ones harder to find.

## Search first

Always, before writing anything:

```bash
gh issue list --repo adamayoung/TMDb --state all --search "<distinctive term>"
```

Use a term from the *symptom*, not your phrasing of the fix — the same defect
gets described three ways. Prefer **commenting on the existing issue** with the
new evidence over opening a near-duplicate. If it is genuinely distinct but
related, file it and cross-link both ways in the body.

## Body template

Every section earns its place: `/triage-issues` re-verifies against these, and a
body without them takes a triage pass to become actionable — which is a pass
nobody scheduled.

```markdown
**Origin:** <what surfaced it — the PR, review, or sweep, and why it was left
out of that change's scope. "Deliberately deferred" and "overlooked" are
different facts; say which.>

## Problem

<What is wrong, in the code's terms. Cite `path/to/File.swift:LINE` — plural,
one per claim. State the version you checked against: "as of `main` @ <sha>".>

## Failure scenario

<Concrete inputs or state → wrong output, crash, or silent loss. Not "this
could be a problem" — the actual path. If you verified it live, say so and give
the numbers.>

## Fix sketch

<Enough for someone else to start without re-deriving your analysis. Name the
files, the shape of the change, and the in-repo precedent to copy if one
exists.>

**Breaking class:** none | source-breaking | behavioural | needs a decision
```

Add `**Decision needed:**` as its own line when the fix is not determined — one
sentence naming the choice, not a discussion of it. That line is what
`/triage-issues` keys on to route an issue to Backlog rather than Ready.

### Two conventions that are easy to get wrong

- **Line numbers rot.** They are still worth giving — they are how a triage pass
  re-verifies you — but say which commit they are as of, so a reader knows
  whether to trust them.
- **This repo's numbers interleave issues and PRs.** A bare `#NNN` is ambiguous.
  Write "issue #NNN" or "PR #NNN" in words, and check with
  `gh api repos/adamayoung/TMDb/issues/NNN --jq .pull_request` if unsure.

## Filing it

```bash
gh issue create --repo adamayoung/TMDb \
  --title "<symptom, not solution — what is wrong, in one line>" \
  --label "<bug|enhancement|documentation|question>" \
  --body-file <path>
```

Then **add it to the board's Backlog column** — an unfiled-to-the-board issue is
invisible to `/triage-issues` until its orphan sweep catches it:

```bash
gh project item-add <number> --owner adamayoung --url <issue-url>
```

Resolve `<number>` by title rather than hard-coding it:

```bash
gh project list --owner adamayoung --format json \
  | jq -r '.projects[] | select(.title == "TMDb") | .number'
```

New items land in Backlog by default. Do **not** set Status, Priority or Size
yourself — those are `/triage-issues`' output, and guessing them here means two
owners for one judgement.

## Titles

The title is what someone scans in a list of forty. Lead with the symptom and
the blast radius:

- Good — `TaggedImageMedia doesn't model media_type "tv", so most tagged images are silently dropped`
- Bad — `Improve TaggedImageMedia` (no symptom), `Add tvSeries case` (solution, not problem)

Do not write "for the next major" or "queue for later" into a title. Whether it
waits is a scheduling decision that changes; the title outlives it, and a stale
"queue this" tells every future reader to defer the thing they should be doing.
