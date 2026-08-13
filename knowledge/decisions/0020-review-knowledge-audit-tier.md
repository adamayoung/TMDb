# ADR-0020: `/review-knowledge` audits on Opus; cross-examination stays on Fable

- **Status:** Accepted (unreleased — tooling only)
- **Date:** 2026-08-13
- **Deciders:** Adam Young, Claude
- **Amends in part:** [ADR-0014](0014-subagent-model-tiers.md)

## Context

[ADR-0014](0014-subagent-model-tiers.md) set the durable part of the policy —
the *shape → tier* mapping — and its 2026-08-07 addendum pinned
`/review-knowledge`'s auditors to a **Fable-class** model, "chosen for
verification depth on the knowledge audit".

Two things prompted revisiting it.

**Cost.** Fable-class pricing is $10/$50 per MTok against Opus at $5/$25, and
the skill fans out **eight** agents per run — four auditors (two lenses × two
trees) plus a four-agent cross-examination round. That made a periodic prose
audit the single most expensive configuration in `.claude/`. Nothing in
`knowledge/` or the retros records the Fable tier catching staleness an Opus
tier missed: the pin was chosen on *expected* depth, never on measured yield.

**The two rounds are not symmetric.** An auditor that misses a finding costs one
cycle — the next audit re-derives it. A cross-examiner that wrongly *refutes* a
finding writes a `· refuted` entry into
[`skill-improvement-log.md`](../skill-improvement-log.md), and the skill's own
Agent Behaviour Contract then makes every later audit **drop that finding
without re-deriving it**. A weak refutation is therefore durable, self-concealing
suppression; a weak audit is not.

> The addendum also miscounted the fan-out as "two audit critics". Correcting a
> factual error is explicitly not a change of mind
> ([`decisions/README.md`](README.md) → *Immutability*), so it is fixed in place
> rather than carried forward.

## Decision

Split the tier by round rather than by skill:

- **Audit round** (four auditors, two lenses × two trees) → **`opus`** at
  `effort: 'high'`.
- **Cross-examination round** (up to four refuters) → **stays `fable`** at
  `effort: 'high'`.

`effort` is deliberately **unchanged** on both rounds. An earlier draft paired
the model change with `high → xhigh`; three independent plan critics observed
that `xhigh` raises thinking tokens — billed as *output*, at 5× the input rate —
so moving both variables at once would have made the saving unmeasurable and
broken the one-variable diagnostic convention ADR-0014 itself relies on ("if
DocC quality ever regresses, the Sonnet pin is the first suspect").

## Consequences

- **Cost falls roughly a quarter.** Eight Fable-tier agents ≈ 16 Opus-equivalents;
  four Opus + four Fable ≈ 12. Less than a blanket downgrade would have saved,
  which is the price of keeping the top tier where a mistake is permanent.
- **One variable moved**, so a regression in audit quality has exactly one
  suspect: the Opus audit pin.
- **The tier split is now load-bearing and easy to "tidy" away.** The skill's
  contract, the block comment above the cross-examination section, and a
  one-line note on the `agent()` options object itself all say why the rounds
  differ and point here — because the natural instinct on reading a two-tier
  workflow is to unify it, and the reader doing that greps `model:` and lands on
  the call site, not on the prose.
- **The saving is projected, not measured** — no run at the new tier exists yet.
  So the skill's report contract now requires **every** run to record its agent
  count, total tokens, and consensus findings by severity in
  [`skill-improvement-log.md`](../skill-improvement-log.md) — the skill's own
  memory, and the reader of the trigger below.

**Revisit when** two consecutive `/review-knowledge` runs record **zero**
`major`-or-`critical` consensus findings while the tree has demonstrably moved
(intervening deliveries that changed build config, target layout or the skills —
`delivery-retros.md` lists them). That is checkable from the log rather than
only after a bug ships, which is *why* the run-record line above is part of this
decision rather than a nicety: without it a zero-finding run leaves no trace and
the trigger has nothing to read.

## Alternatives considered

- **All eight agents on Opus.** The full ~50% saving and a simpler one-tier
  story, but it moves the refutation round — the only stage whose mistakes are
  written to permanent memory — to a lower tier on cost grounds alone. Rejected:
  the asymmetry above is a real mechanism, not a hypothetical.
- **Leave all eight on Fable.** No change, no risk, no saving. Rejected: the
  original pin was never evidence-backed, and the audit round is bulk repo
  reading, which is the shape ADR-0014 already assigns below the top tier.
- **All eight on Opus, plus adjudicating every refutation against the tree before
  it is written to the log.** Fixes the underlying hazard rather than paying a
  model tier to mask it — a Fable refuter can be wrong too — and is probably the
  right long-term shape. Rejected *here* only as scope: it rewrites the skill's
  consensus procedure, which this delivery does not otherwise touch.

## What this does not change

ADR-0014's Haiku (`tooling-runner`, first-pass CI diagnosis), Sonnet
(`documentation-writer`) and Opus (`code-reviewer`, `/review-changes`,
`/review-plan` critics, the `/deliver` panel) mappings stand unamended, as does
its rejection of Fable-class `/review-plan` critics — *"the price on every plan
review isn't justified while Opus-tier critics are converging fine; revisit if
they start missing blockers"*. A conditional variant of that escalation was
drafted alongside this change and **dropped before implementation**: it delivered
no cost saving, its trigger could never fire for the reflexive `.claude/` changes
this repo's defect record is made of, and it collided with the recorded decision
that the delivery-weight vocabulary stays binary. It is filed instead as issue
[#450](https://github.com/adamayoung/TMDb/issues/450), against ADR-0014's
existing revisit trigger.
