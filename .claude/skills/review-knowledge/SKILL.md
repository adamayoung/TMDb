---
name: review-knowledge
description: Audit the knowledge/ base for staleness, self-contradiction, and drift from its own retention policy — two independent adversarial critics verify every load-bearing claim against the current tree, cross-examine each other, and reach a consensus on if/what needs changing. Use periodically, after a run of deliveries that changed build config or target layout, or whenever you suspect the knowledge base has aged out of true.
---

# Review Knowledge

Audit `knowledge/` against reality. A knowledge base is a **cache of currently-true
facts** (`knowledge/README.md` → *Maintenance & retention*), and caches go stale
silently: writes are engineered here (`/capture-knowledge`, `/deliver`'s capture
phase) but retirements are not, so truth decays exactly where the code moves
fastest — `Makefile`, `.github/workflows/ci.yml`, `Package.swift`, target layout,
toolchain pins.

Two independent adversarial critics audit it, cross-examine each other's findings,
and converge on a consensus. You adjudicate only what survives disputed.

> The base's own entries are the thing under suspicion. An entry that reads
> confidently and cites a file is exactly the kind that goes stale unnoticed —
> confidence is not currency here. **Verify against the tree or drop the claim.**

## Agent Behaviour Contract

The point of this skill: do these by default, without being reminded.

1. **Two critics, two lenses, one Workflow.** Run the embedded `Workflow` below.
   It fans out exactly two auditors in parallel, each pinned to the **`fable`**
   model, then runs a **cross-examination** round where each sees the other's
   findings. Invoking this skill is itself the opt-in to call `Workflow`.
2. **Verify, never trust the prose.** Every finding must be checked against the
   actual tree (`Read`/`Grep`/`Bash`) and cite `file:line`. A finding sourced only
   from reading the knowledge base itself is inadmissible — that is the failure
   mode being audited.
3. **Critics are read-only.** They audit and report. They do not edit `knowledge/`,
   do not fix anything, and do not open PRs. Applying is the conductor's job, after
   the user approves.
4. **"Nothing needs changing" is a real, respectable outcome.** A critic that
   finds a file accurate must say so and name what it checked. Do not manufacture
   findings to look thorough — a padded audit trains the next one to be ignored.
5. **Adjudicate only genuine deadlock.** After cross-examination, findings both
   critics confirm are consensus and need no debate from you. Resolve only what
   remains disputed, with a stated rationale grounded in the tree.
6. **Report before you fix.** Present the consensus, get the user's go-ahead, then
   apply. Never silently rewrite the knowledge base on the strength of an audit.

## Scope

Everything under `knowledge/`:

| File | What decay looks like here |
| --- | --- |
| `gotchas.md` | A trap that was fixed upstream but still reads as live; a tooling pin, path, or filter that moved; three generations of truth accreted into one entry. |
| `tmdb-api-notes.md` | A live-API behaviour that changed; a field that is no longer nullable; a claim never verified against a real response. |
| `decisions/` | Numbering collisions; a status still saying "targets X" after X shipped; an ADR superseded in fact with no forward link; the index out of sync. |
| `delivery-retros.md` | Over its ~12-entry rolling window; prose whose lesson is already folded into a skill (spent — distil it). |
| `skill-improvement-log.md` | A `deferred`/`rejected` entry whose "Reconsider when" condition has **already been met**. This is the highest-cost staleness in the base: the recurring-pattern scan reads this file as dedup memory, so a stale entry actively misinforms it. |
| `breaking-backlog.md` | An item that shipped, or one whose "breaking" premise no longer holds. |
| `README.md` | The stated policy no longer matching what the files actually do. |

Also in scope: **contradictions with `CLAUDE.md`**. When the base and `CLAUDE.md`
disagree, determine which is right from the tree — the base is often the one that
already diagnosed the truth, and nobody propagated it upstream.

## Run the audit (Workflow)

Two auditors run as a single `Workflow` so the **`fable`** model is guaranteed per
agent and each verdict is schema-validated rather than free-text. No `args` are
needed — the scope is the repository itself.

```javascript
export const meta = {
  name: 'review-knowledge-critics',
  description: 'Two adversarial Fable critics audit the knowledge base, then cross-examine',
  phases: [
    { title: 'Audit', detail: 'two fable critics, one per lens' },
    { title: 'Cross-examine', detail: 'each critic tries to refute the other' },
  ],
  model: 'fable',
}

const SEVERITY = `Grade by CONSEQUENCE IF THE ENTRY IS TRUSTED AS WRITTEN, not by your confidence:
- critical: acting on this entry causes real harm or wasted work — it states a falsehood about the current tree, contradicts another entry, or (in skill-improvement-log.md) misinforms the dedup scan that reads it as memory.
- major: materially misleading — a stale path/pin/filter, an ADR status or number defect, a policy the base states but does not follow, a missing cross-reference that hides a correction.
- minor: hygiene — ordering, duplication, a cosmetic defect, a window one entry over.
If unsure whether a finding is real, set "confidence" to low/medium and say so in the claim — do NOT inflate or deflate severity to express doubt.`

const LENSES = [
  {
    key: 'accuracy',
    title: 'Accuracy & Staleness',
    brief: `Assume the knowledge base is lying to you. For every load-bearing factual claim, check it against the CURRENT tree and flag what no longer holds. Prioritise claims about things that move: Makefile targets and variables, .github/workflows/ci.yml (toolchain pins, job names, lint scopes, test filters), Package.swift (targets, dependencies, exclude lists), test-target layout and file locations, swiftlint/swiftformat pins, and live-API behaviours. Hunt specifically for: entries describing a FIXED problem as still live; entries that contradict EACH OTHER; entries that contradict CLAUDE.md; and entries that have accreted several generations of truth instead of being rewritten to the present. Read git log for the PRs an entry cites — an entry whose fix shipped should have been retired.`,
  },
  {
    key: 'structure',
    title: 'Structure, Policy Compliance & Gaps',
    brief: `Audit the base against its OWN stated rules in knowledge/README.md (rolling windows, retire-what-is-untrue, ADR immutability and superseding, do-not-pre-split, dated grep-friendly headings) and against knowledge/decisions/README.md (numbering, status upkeep). Hunt for: duplicate or out-of-order headings, numbering collisions, index drift, broken or missing cross-references, orphaned files, statuses that lag reality, entries filed under the wrong file, and windows that have drifted. Then ask what is MISSING: a decision made but never recorded as an ADR, a recurring trap with no entry, a deferred item with no trigger that would ever surface it. Check the base applies its own hygiene rules TO ITSELF.`,
  },
]

const FINDING_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    lens: { type: 'string' },
    verdict: { type: 'string', enum: ['healthy', 'needs-fixes', 'materially-stale'] },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          id: { type: 'string', description: 'short stable slug, e.g. "xcode-pin-stale"' },
          severity: { type: 'string', enum: ['critical', 'major', 'minor'] },
          confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
          claim: { type: 'string', description: 'one-line statement of the defect' },
          knowledgeLocation: { type: 'string', description: 'the knowledge/ file:line at fault' },
          evidence: { type: 'string', description: 'how you VERIFIED it against the tree — the file:line or command whose output proves the entry wrong' },
          fix: { type: 'string', description: 'the concrete change: rewrite / retire / renumber / relocate, and to what' },
        },
        required: ['id', 'severity', 'confidence', 'claim', 'knowledgeLocation', 'evidence', 'fix'],
      },
    },
    verifiedAccurate: { type: 'string', description: 'load-bearing claims you checked that ARE still true — say what you checked and how' },
  },
  required: ['lens', 'verdict', 'findings'],
}

const REBUTTAL_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    assessments: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          id: { type: 'string', description: "the other critic's finding id" },
          position: { type: 'string', enum: ['confirm', 'refute', 'amend'] },
          reasoning: { type: 'string', description: 'evidence from the tree — not an opinion' },
          amendedSeverity: { type: 'string', enum: ['critical', 'major', 'minor'], description: 'only when position is amend' },
        },
        required: ['id', 'position', 'reasoning'],
      },
    },
    missedByBoth: { type: 'string', description: 'anything the other report made you realise BOTH of you missed' },
  },
  required: ['assessments'],
}

const READONLY = `You are READ-ONLY. Read the repo freely (Read/Grep/Bash for git log, grep, ls) but do NOT edit any file, do not fix anything, and do not run builds or tests (slow and unnecessary). `

phase('Audit')
const audits = await parallel(LENSES.map((lens) => () =>
  agent(
    `You are an ADVERSARIAL auditor of the engineering knowledge base at knowledge/ in this repo, working the "${lens.title}" lens.\n\n` +
    `${lens.brief}\n\n` +
    `${READONLY}\n\n` +
    `EVERY finding must be VERIFIED against the current tree and cite the evidence that proves it — the file:line or command output that contradicts the entry. A finding derived only from reading the knowledge base is inadmissible; that credulity is the exact failure mode you are auditing. Equally: do NOT manufacture findings to look thorough. If a file is accurate, say so in "verifiedAccurate" and name what you checked.\n\n` +
    `SEVERITY RUBRIC:\n${SEVERITY}`,
    { label: `audit:${lens.key}`, phase: 'Audit', model: 'fable', effort: 'high', schema: FINDING_SCHEMA }
  ).then((v) => v && { ...v, lens: lens.title, key: lens.key })
))

const live = audits.filter(Boolean)
if (live.length < 2) {
  log(`WARNING: only ${live.length} of 2 auditors returned — cross-examination skipped, treat the result as unreconciled`)
  return { audits: live, rebuttals: [], degraded: true }
}

phase('Cross-examine')
const rebuttals = await parallel(live.map((mine, i) => () => {
  const theirs = live[1 - i]
  return agent(
    `You audited this knowledge base through the "${mine.lens}" lens. Another independent auditor worked the "${theirs.lens}" lens. Your job now is to CROSS-EXAMINE their findings — try to refute each one.\n\n` +
    `Their findings:\n${JSON.stringify(theirs.findings, null, 2)}\n\n` +
    `For each, independently verify it against the tree and take a position: "confirm" (you checked, it holds), "refute" (you checked, it is wrong or the entry is actually fine — say what they misread), or "amend" (real, but the severity or the proposed fix is wrong — give the corrected one).\n\n` +
    `Default to REFUTE when the evidence is thin. A finding that cannot be independently reproduced from the tree should not survive into the consensus. Do not confirm out of collegiality.\n\n` +
    `${READONLY}\n\n` +
    `Finally, in "missedByBoth", note anything their report made you realise you BOTH missed.`,
    { label: `cross:${mine.key}`, phase: 'Cross-examine', model: 'fable', effort: 'high', schema: REBUTTAL_SCHEMA }
  ).then((r) => r && { by: mine.lens, ...r })
}))

return { audits: live, rebuttals: rebuttals.filter(Boolean) }
```

To iterate on the script, edit the file path the `Workflow` tool returns and
re-invoke with `{ scriptPath }` rather than resending it.

## Reach the consensus

The critics have already done the reconciling work — read it, don't redo it:

1. **Consensus findings** — raised by one critic and **confirmed** by the other.
   These are settled. Do not re-litigate them; carry them at the confirmed
   severity (or the amended one, if the cross-examiner amended and justified it).
2. **Refuted findings** — dropped. Record them in the report as *raised and
   refuted*, with the refutation's reasoning, so the next audit doesn't re-raise
   them cold.
3. **Disputed** — a finding whose rebuttal is itself unconvincing (asserts rather
   than evidences). **This is the only place you adjudicate.** Verify it yourself
   against the tree and make the call, stating what you checked.
4. **`missedByBoth`** — fold in anything either critic surfaced here; verify it
   yourself first, since by definition neither audited it properly.
5. **If a critic died** (`degraded: true`), say so plainly. A single unreconciled
   audit is a weaker result, not an equivalent one — offer to re-run.

Present a consensus table: finding · severity · agreement (confirmed / adjudicated
/ refuted) · the fix. Then state the **verdict for the base as a whole**, and be
willing to conclude *no changes needed*.

## Apply — only after the user agrees

Present the consensus and **stop**. On the go-ahead:

- Group the fixes into one PR unless the user says otherwise. Branch off `main`
  first — never edit on `main` (`CLAUDE.md` → *Branching*).
- **Rewrite to the present tense, don't append corrections.** The retention policy
  is describe-the-present: an entry that has accreted "…update: actually…" layers
  should be rewritten as one entry that states what is true now. Git history is
  the archive.
- **Retire, don't hedge.** When a trap was fixed upstream, delete the entry. Keep
  only the part that is still load-bearing (typically: the invariant somebody must
  maintain so it doesn't come back).
- ADR corrections are exempt from immutability: fixing a stale status, a broken
  link, or a numbering collision is not a change of mind. A change of *decision*
  still needs a new ADR that supersedes the old one.
- If the audit found a **class** of staleness rather than instances, fix the
  trigger too — an audit that only patches entries guarantees the next audit finds
  the same class again.

Close with what changed, what was deliberately left, and anything needing a human
call.

## Relationship to other skills

- **`/capture-knowledge`** writes entries; this skill retires them. They are the
  two halves of keeping the base a cache rather than an archive.
- **`/deliver`** runs `/capture-knowledge` pre-PR, and its capture phase carries
  the **targeted** staleness sweep (when a diff touches build config, re-check the
  entries citing it). This skill is the **untargeted, periodic** counterpart — it
  catches decay no single delivery's diff would have pointed at.
- **`/review-plan`** is the same adversarial-critics-then-consensus shape applied
  to a plan instead of the knowledge base.
