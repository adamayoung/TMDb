# ADR-0014: Model-tier policy for skills and subagents

- **Status:** Accepted (amended in part by
  [ADR-0020](0020-review-knowledge-audit-tier.md))
- **Date:** 2026-07-06
- **Deciders:** Adam Young, Claude

## Context

The project's Claude Code pipeline fans work out to subagents in three very
different shapes: mechanical run-and-summarise jobs (builds, test runs,
first-pass CI-log diagnosis), bulk-but-style-sensitive generation (DocC
sweeps), and high-judgment review (code review, plan critics, the `/deliver`
auto-panel). Before this ADR the model choice was scattered: the four
build/test skills each embedded a `model: haiku` instruction the caller had
to remember, both agent definitions used `model: inherit` (so bulk DocC
billed at the session model's rate, and review quality silently followed
whatever session spawned it), and a wrong Haiku CI diagnosis had no
escalation path — it would be retried on the same tier after costing a full
fix→push→CI round trip.

A relevant mechanic: an Agent-tool call-site `model:` override **beats** the
agent definition's frontmatter pin, so a frontmatter pin acts as a *floor*,
not a ceiling.

## Decision

Assign model tiers by the shape of the work, and pin them where the work is
defined (agent frontmatter or the skill's call-site instruction):

- **Haiku — mechanical runners and first-pass diagnosis.** The
  `tooling-runner` agent (`/build`, `/build-for-testing`, `/test`,
  `/integration-test`) and the first diagnosis attempt in `/fix-pr-checks`.
  The playbook (skill/agent prompt) carries the judgment — known gotchas,
  failure taxonomies, report contracts — so the executor can be cheap and
  fast.
- **Sonnet — bulk, style-sensitive generation.** The `documentation-writer`
  agent: DocC sweeps follow a fixed convention (`document-swift`) and don't
  reward top-tier reasoning.
- **Opus — judgment floors and escalation.** The `code-reviewer` agent's
  frontmatter (a floor for spawns without a call-site pin), the
  `/review-changes` find/verify stages, the `/review-plan` critics, the
  `/deliver` auto-panel, and the `/fix-pr-checks` **re-diagnosis** of a check
  that failed again after a fix (the repeat proves the cheap tier missed;
  prior-attempt context travels with the escalation).

The smart model always sits **downstream** of the cheap one: Haiku reports,
the conductor (session model) applies and verifies fixes, and Opus grades or
re-diagnoses only where judgment demonstrably matters.

## Consequences

- Model choice is no longer a caller responsibility for the runners — the
  pin lives in `tooling-runner.md` (and, since PR #466, `check-diagnoser.md`
  for the `/fix-pr-checks` first attempt) and can't be forgotten.
- Review quality has a floor: `code-reviewer` never silently degrades below
  Opus in a cheaper session, while call sites may still override upward.
- Bulk documentation gets cheaper without a quality change worth caring
  about; if DocC quality ever regresses, the Sonnet pin is the first suspect.
- A repeated CI failure now costs one Opus diagnosis instead of a second
  wasted CI round trip.
- The tiers name the current line-up (Haiku 4.5, Sonnet, Opus). A future
  model family shift (e.g. pinning the top judgment calls to a Fable-class
  model) revisits this ADR — the *shape → tier* mapping is the durable part,
  not the model names.
- *Addendum (2026-08-07; amended 2026-08-13 by
  [ADR-0020](0020-review-knowledge-audit-tier.md)):* `/review-knowledge` (added
  after this ADR) pinned its auditors to a **Fable-class** model — the first
  judgment role above the Opus floor, chosen for verification depth on the
  knowledge audit. It fans out **four** auditors (two lenses over two trees)
  plus a four-agent cross-examination round; "two audit critics" as originally
  written was a miscount, corrected here. **ADR-0020 splits that pin by round**
  — the audit round moved to Opus, the cross-examination round stays
  Fable-class because its refutations are written to permanent memory. The
  shape → tier mapping is unchanged, and the trigger for revisiting the
  remaining Opus pins (the `/review-plan` critics, the `/deliver` panel) stays
  "critics start missing blockers".
- *Addendum (2026-08-19, PR #466):* the `/fix-pr-checks` first-attempt Haiku
  pin moved from call-site prose into the new `check-diagnoser.md` agent's
  frontmatter — the floor mechanic above, exercised: the call-site
  `model: opus` re-diagnosis still overrides it, and a spawn that forgets
  `model` now lands on Haiku instead of the session model. (The PR's plan
  originally said *no* pin, reasoning a pin would block the escalation —
  the review caught that as contradicting this ADR's mechanic.) Tier mapping
  unchanged.

## Alternatives considered

- **`inherit` everywhere** — follows the session model, but makes review
  quality and doc cost accidents of which session spawned the agent.
- **Opus for CI diagnosis from the first attempt** — most CI failures are
  mundane (the error line is in the log); paying top-tier rates to read
  2,000 lines of compiler output is the most expensive possible use of it.
  Escalation-on-repeat captures the benefit at a fraction of the cost.
- **Pinning the `/review-plan` critics and `/deliver` panel to a
  Fable-class model** — capability ceiling is higher, but the price on
  every plan review isn't justified while Opus-tier critics are converging
  fine; revisit if they start missing blockers.
