# ADR-0016: Auto-mode panel as three independent jurors, in `.claude/workflows/`

- **Status:** Accepted (unreleased — tooling only, no library impact)
- **Date:** 2026-07-29
- **Deciders:** Adam Young

## Context

`/deliver auto` resolves every mid-run stop-and-ask decision with an
"adversarial panel". As written it was **prose only** — no tool named, no
schema, no model-pin mechanism, no dead-agent rule — so it was not implementable
as specified, in the one mode that runs with nobody watching.

It was also **methodologically broken**. The three roles were *Proceed* (argues
for continuing), *Stop* (argues for halting) and *Devil's advocate* (attacks
whichever way looks easiest). Two of the three verdicts were therefore **fixed
by role before any evidence was read**, so "majority wins" tallied one free vote
and two constants — and the free vote belonged to the agent instructed *not* to
reason toward the right answer. That is the "reads as rigorous but is
decorative" failure this repo already names for process rules, applied to a
decision procedure.

## Decision

### Advocacy is for generating arguments; verdicts must be free

Role pre-commitment helps *build* a case and invalidates *reaching* one. A
two-round design (assigned advocates brief, independent jurors rule) was
considered and rejected as speculative generality: it costs five `opus`/`xhigh`
agents per decision, at every decision point, for a mode that **has never been
exercised by a real delivery**. Nothing downstream consumed the briefs.

So: **one round of three independent jurors**, `opus`/`xhigh`,
schema-validated, each returning a free verdict, a confidence, the single
deciding fact, and **what it verified first-hand**. A juror that cannot verify
the decisive claim is instructed to vote `stop`.

### The tally is deliberately asymmetric

`proceed` requires a strict majority of **live** jurors **and** at least two
live jurors; everything else is `stop`. **A dead panel is not a proceed** —
Phase 6's "a dead grader is not a pass" applied here. The asymmetry is
justified rather than squeamish: `stop` hands back to a human and is
recoverable; `proceed` may not be.

### Guard rails are `throw`s, not prose

- An unlisted `decision` **throws**. This is what keeps the hard-stop carve-outs
  (data loss, breaking change, credential leak, clear exploit) hard *by
  construction*: an unattended run cannot invent a new delegable decision.
- A conductor-supplied `recommendation`/`preference`/`suggested` **throws**.
  There is nowhere to put a preference, so one cannot leak into the jurors'
  reading — independence by construction rather than by exhortation.
- **Phase 11 is not delegable at all.** A `proceed` there would authorise an
  unattended run to edit and push the repo's own skill files, including the
  script defining the panel that authorised it. Auto mode records proposals as
  deferred and applies none.

Both guards were verified live: each throws with **zero agents spawned**.

### The script lives in `.claude/workflows/`, not embedded

The other Workflow scripts (`review-plan`, `review-knowledge`, `review-changes`
and `fix-pr-checks` — four as of 2026-08-13) are embedded in their `SKILL.md`,
and each runs **once per skill invocation**, so re-authoring costs nothing. The
panel runs at **many decision points per run** — seven as of 2026-08-20, and the
count grows whenever a mode adds a stop-and-ask — from a context that has been
compacting for hours. The exact number lives in
`.claude/workflows/deliver-panel.js`'s `POINTS` enum and in
`deliver/references/auto-and-async.md`; it is deliberately not restated here,
because a count in a third place is one more thing to drift.

An embedded script is **re-authored** each time; a file is **executed**. Drift
between invocations in a *decision procedure* — the tally rule, the dead-agent
bar — is a correctness bug, not an inefficiency. That, not token cost, is the
reason for the split. A repo-relative `scriptPath` was **verified to resolve**
before committing to this placement.

## Consequences

- Auto mode's decision procedure is now executable, uniform across invocations,
  and schema-validated; its audit trail is a preformatted `ledgerLine`.
- **`.claude/workflows/` joins Phase 5's security-surface list** — a committed
  script that spawns agents and gates autonomous decisions belongs beside
  `.claude/settings*`. This ADR's placement decision is what creates that
  surface, so closing it is part of the same change.
- The repo now has **two conventions** for Workflow scripts. The rule is
  drift-sensitivity: **orchestration-only scripts embed in their `SKILL.md`;
  a script that encodes a decision procedure (rubrics, tally rules,
  guard thresholds) or runs headless lives in `.claude/workflows/`** — an
  executed file cannot drift between invocations the way a re-authored
  embedded script can, and for decisions that drift is a correctness bug.
  (As originally written the rule keyed on *frequency* — "once per
  invocation → embed; many times per run → file" — see the 2026-08-19
  addendum for why that proxy was replaced.)
- Phase 11 proposals now always wait for a human, so the default auto path
  pushes nothing after the ready gate.
- **The jurors themselves remain unexercised** — only the guards have run. Auto
  mode has still never completed a real delivery, and this ADR does not change
  that.
- *Addendum (2026-08-19, knowledge-drift audit):* PR #464 committed
  `.claude/workflows/triage-issues.js` — a once-per-invocation script — as a
  file, violating the frequency rule while matching this ADR's own deeper
  rationale (it carries the triage `RUBRIC` constants and runs headless, so
  re-authoring drift would corrupt decisions). The rule failed because it
  named the proxy (frequency) instead of the criterion (drift-sensitivity of
  decisions); the Consequences bullet above now states the criterion. The
  census is six scripts: four embedded (`review-plan`, `review-knowledge`,
  `review-changes`, `fix-pr-checks`), two files (`deliver-panel.js`,
  `triage-issues.js`). Placement has no mechanical gate; the standing hook is
  that `.claude/workflows/` sits on the security-surface list, so every new
  file there passes a reviewer — who should check it against this rule.
