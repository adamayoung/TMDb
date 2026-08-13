---
name: review-knowledge
description: Audit the knowledge/ base and the .claude/ skills, agents and workflows for staleness, self-contradiction, and drift from their own stated rules — four independent adversarial auditors (two lenses over two trees) verify every load-bearing claim against the current tree, cross-examine each other within their tree, and reach a consensus on if/what needs changing. Use periodically, after a run of deliveries that changed build config, target layout or the skills themselves, or whenever you suspect the docs have aged out of true.
---

# Review Knowledge

Audit `knowledge/` **and `.claude/`** against reality. Both are a **cache of currently-true
facts** (`knowledge/README.md` → *Maintenance & retention*), and caches go stale
silently: writes are engineered here (`/capture-knowledge`, `/deliver`'s capture
phase) but retirements are not, so truth decays exactly where the code moves
fastest — `Makefile`, `.github/workflows/ci.yml`, `Package.swift`, target layout,
toolchain pins.

Four independent adversarial auditors — an accuracy lens and a structure lens over
each of the two trees — audit them, cross-examine each other's findings within
their tree, and converge on a consensus. You adjudicate only what survives
disputed.

> The base's own entries are the thing under suspicion. An entry that reads
> confidently and cites a file is exactly the kind that goes stale unnoticed —
> confidence is not currency here. **Verify against the tree or drop the claim.**

## Agent Behaviour Contract

The point of this skill: do these by default, without being reminded.

1. **Two lenses × two trees, one Workflow.** Run the embedded `Workflow` below.
   It fans out **four** auditors in parallel — each lens against each tree —
   every one pinned to the **`opus`** model, then runs a **cross-examination**
   round **paired within each tree**, so the two lenses challenge each other on
   the same material. Invoking this skill is itself the opt-in to call
   `Workflow`. A tree whose pair doesn't both return is reported
   `unreconciled`, never as consensus.
   **The cross-examination stays on `fable` — do not unify the two tiers.**
   The rounds are not symmetric: a refutation is written to the *permanent*
   refutation memory (item 2) and silently suppresses that finding on every
   later audit, so a weak refuter costs far more than a weak auditor. An audit
   miss, by contrast, is re-derivable next run. See
   [ADR-0020](../../../knowledge/decisions/0020-review-knowledge-audit-tier.md).
2. **Consult the refutation memory first.** Before reporting, grep
   [`knowledge/skill-improvement-log.md`](../../../knowledge/skill-improvement-log.md)
   for `· refuted` entries and drop any finding already settled there whose
   *Reconsider when* condition is unmet. Say in the report how many you dropped
   this way. Re-deriving a settled refutation costs a full audit cycle and buys
   nothing.
3. **Verify, never trust the prose.** Every finding must be checked against the
   actual tree (`Read`/`Grep`/`Bash`) and cite `file:line`. A finding sourced only
   from reading the knowledge base itself is inadmissible — that is the failure
   mode being audited.
4. **Critics are read-only.** They audit and report. They do not edit `knowledge/`,
   do not fix anything, and do not open PRs. Applying is the conductor's job, after
   the user approves.
5. **"Nothing needs changing" is a real, respectable outcome.** A critic that
   finds a file accurate must say so and name what it checked. Do not manufacture
   findings to look thorough — a padded audit trains the next one to be ignored.
6. **Adjudicate only genuine deadlock.** After cross-examination, findings both
   critics confirm are consensus and need no debate from you. Resolve only what
   remains disputed, with a stated rationale grounded in the tree.
7. **Report before you fix.** Present the consensus, get the user's go-ahead, then
   apply. Never silently rewrite the knowledge base on the strength of an audit.

## Scope

Two trees. First, everything under `knowledge/`:

| File | What decay looks like here |
| --- | --- |
| `gotchas.md` | A trap that was fixed upstream but still reads as live; a tooling pin, path, or filter that moved; three generations of truth accreted into one entry. |
| `tmdb-api-notes.md` | A live-API behaviour that changed; a field that is no longer nullable; a claim never verified against a real response. |
| `decisions/` | Numbering collisions; a status still saying "targets X" after X shipped; an ADR superseded in fact with no forward link; the index out of sync. |
| `delivery-retros.md` | Over its ~12-entry rolling window; prose whose lesson is already folded into a skill (spent — distil it). |
| `skill-improvement-log.md` | A `deferred`/`rejected` entry whose "Reconsider when" condition has **already been met**. This is the highest-cost staleness in the base: the recurring-pattern scan reads this file as dedup memory, so a stale entry actively misinforms it. |
| `next-major.md` | An item that shipped, or one whose "breaking" premise no longer holds. It is a **queue**: anything still listed after its major version tagged is a process failure, not a backlog item. |
| `README.md` | The stated policy no longer matching what the files actually do. |

Also in scope: **`CLAUDE.md` and everything under `.claude/`** — skills, agents,
`workflows/`, and `.github/CODE_REVIEW.md`. This tree is *larger and more
normative* than `knowledge/`, decays the same way, and until 2026-08-12 had no
periodic audit at all — an audit that month found most of its defects here, not
in `knowledge/`.

| Where | What decay looks like here |
| --- | --- |
| A skill's prose | A `make` target, CI job name, path, test filter or tool version that moved; a count quoted from another file. |
| A rule stated in two places | The copies drift; one silently becomes wrong. Prefer one owner and a pointer. |
| A rule with no enforcement | Stated as advice where a gate, hook or `tools` allowlist could carry it — this repo's recurring failure (`#368`). |
| Precedence clauses | "If X and this file disagree, the file wins" — check the file actually says what X assumes, or X's rule is inert. |
| Two rules sharing one key | Two mandated report lines with the same name, one retro slot: the loser vanishes while the slot still looks filled. |
| A skill's handoff | Skill A delegates to B without passing the argument B needs, so B falls back to a default A just forbade. |

When the base and `CLAUDE.md` disagree, determine which is right from the tree —
the base is often the one that already diagnosed the truth, and nobody
propagated it upstream.

## Run the audit (Workflow)

Four auditors run as a single `Workflow` so the **model and effort are
guaranteed per agent** — `opus` for the audit round, `fable` for the
cross-examination (Agent Behaviour Contract item 1) — and each verdict is
schema-validated rather than free-text. No `args` are needed — the scope is the
repository itself.

```javascript
export const meta = {
  name: 'review-knowledge-critics',
  description: 'Four adversarial Opus auditors (2 lenses x 2 trees), then a Fable cross-examination',
  phases: [
    { title: 'Audit', detail: 'four opus/high auditors: each lens over each tree' },
    { title: 'Cross-examine', detail: 'lenses refute each other, paired within a tree', model: 'fable' },
  ],
  model: 'opus',
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
    brief: `Assume the text is lying to you. For every load-bearing factual claim, check it against the CURRENT tree and flag what no longer holds. Prioritise claims about things that move: Makefile targets and variables, .github/workflows/ci.yml (toolchain pins, job names, lint scopes, test filters), Package.swift (targets, dependencies, exclude lists), test-target layout and file locations, swiftlint/swiftformat pins, skill and tool names, and live-API behaviours. Hunt specifically for: text describing a FIXED problem as still live; passages that contradict EACH OTHER; passages that contradict CLAUDE.md; and text that has accreted several generations of truth instead of being rewritten to the present. Read git log for the PRs a passage cites — one whose fix shipped should have been retired. A cited file:line that no longer points at what it claims is itself a defect, and so is a claimed mechanism (a git hook, a make target, a tool, a skill) that does not exist — verify a mechanism by looking for it, never by trusting the sentence.`,
  },
  {
    key: 'structure',
    title: 'Structure, Policy Compliance & Gaps',
    brief: `Audit the tree against its OWN stated rules, and against what its siblings say about it. Hunt for: duplicate or out-of-order headings, numbering collisions, index drift, broken or missing cross-references, orphaned files, statuses that lag reality, content filed in the wrong place, and windows that have drifted. Then ask what is MISSING: a decision made but never recorded, a recurring trap with no entry, a deferred item with no trigger that would ever surface it, a rule stated where nothing enforces it. Check the tree applies its own hygiene rules TO ITSELF.`,
  },
]

// Both lenses run against BOTH trees — four audits. Widening the scope prose
// without widening these briefs is how this skill silently audited only half
// the repo while its own scope table claimed otherwise (#443).
const TREES = [
  {
    key: 'knowledge',
    title: 'the engineering knowledge base at knowledge/',
    scope: `Everything under knowledge/: gotchas.md, tmdb-api-notes.md, decisions/ (the ADRs, their README index, and 0000-template.md), delivery-retros.md, skill-improvement-log.md, next-major.md, README.md. Its own rules live in knowledge/README.md — rolling windows, retire-what-is-no-longer-true, ADR immutability and superseding, do-not-pre-split, dated grep-friendly headings, and CITE THE PR THAT DID THE WORK, NOT THE ISSUE (this repo's numbers interleave issues and PRs, so check each cited number with \`gh api\`) — and in knowledge/decisions/README.md: numbering, the 0000-template shape, and status upkeep, where an unreleased CHANGELOG section is NOT a release, only a tag is.`,
  },
  {
    key: 'claude',
    title: 'the operating instructions in CLAUDE.md, .claude/ and .github/CODE_REVIEW.md',
    scope: `CLAUDE.md, every SKILL.md and reference file under .claude/skills/, .claude/agents/*.md, .claude/workflows/*.js, .claude/settings.json, and .github/CODE_REVIEW.md. This tree is LARGER and MORE NORMATIVE than knowledge/ and decays the same way. Its decay modes, in the order they have actually bitten this repo: a rule stated in two or three places where the copies drift apart; a rule stated as advice where a gate, hook or frontmatter tools-allowlist could enforce it; a precedence clause ("if your memory and the file disagree, the file wins") pointing at a file that no longer says what the caller assumes, leaving the rule inert; two rules sharing one key, so the loser vanishes while the slot still looks filled; a skill delegating to another without passing the argument that skill needs, so it silently falls back to a default the caller just forbade; a phase mandated to write state that no phase actually writes; and a claimed mechanism that does not exist.`,
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
          location: { type: 'string', description: 'the file:line at fault (in either audited tree)' },
          evidence: { type: 'string', description: 'how you VERIFIED it against the tree — the file:line or command whose output proves the entry wrong' },
          fix: { type: 'string', description: 'the concrete change: rewrite / retire / renumber / relocate, and to what' },
        },
        required: ['id', 'severity', 'confidence', 'claim', 'location', 'evidence', 'fix'],
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
const JOBS = TREES.flatMap((tree) => LENSES.map((lens) => ({ tree, lens })))
const audits = await parallel(JOBS.map(({ tree, lens }) => () =>
  agent(
    `You are an ADVERSARIAL auditor of ${tree.title} in this repo, working the "${lens.title}" lens.\n\n` +
    `SCOPE — audit ONLY this tree, and cite every finding inside it:\n${tree.scope}\n\n` +
    `LENS:\n${lens.brief}\n\n` +
    `${READONLY}\n\n` +
    `EVERY finding must be VERIFIED against the current tree and cite the evidence that proves it — the file:line or command output that contradicts the text. A finding derived only from reading the documentation is inadmissible; that credulity is the exact failure mode you are auditing. Equally: do NOT manufacture findings to look thorough. If a file is accurate, say so in "verifiedAccurate" and name what you checked.\n\n` +
    `SEVERITY RUBRIC:\n${SEVERITY}`,
    { label: `audit:${tree.key}:${lens.key}`, phase: 'Audit', model: 'opus', effort: 'high', schema: FINDING_SCHEMA }
  ).then((v) => v && { ...v, lens: lens.title, key: lens.key, tree: tree.key, treeTitle: tree.title })
))

const live = audits.filter(Boolean)

// Cross-examine WITHIN each tree, so the two lenses challenge each other on the
// same material. A tree with fewer than two survivors is reported UNRECONCILED
// rather than passed off as consensus — a dead auditor is not a clean bill.
//
// This round stays on `fable` while the audit round above runs on `opus`, and
// the asymmetry is deliberate: a refutation here is written to the PERMANENT
// refutation memory in skill-improvement-log.md and suppresses that finding on
// every later audit, whereas a missed finding upstream is re-derived next run.
// Do not unify the two tiers without reading ADR-0020.
const groups = TREES.map((tree) => ({ tree, members: live.filter((a) => a.tree === tree.key) }))
const unreconciled = groups.filter((g) => g.members.length < 2).map((g) => g.tree.key)
unreconciled.forEach((k) => log(`WARNING: ${k} had fewer than 2 auditors return — its findings are UNRECONCILED, not consensus`))
if (live.length === 0) return { audits: [], rebuttals: [], unreconciled, degraded: true }

phase('Cross-examine')
const rebuttals = await parallel(
  groups.filter((g) => g.members.length === 2).flatMap((g) =>
    g.members.map((mine, i) => () => {
      const theirs = g.members[1 - i]
      return agent(
        `An audit of ${g.tree.title} was run through the "${mine.lens}" lens — those findings are YOURS, reproduced below. Another independent auditor worked the "${theirs.lens}" lens over the same tree. Your job now is to CROSS-EXAMINE their findings — try to refute each one.\n\n` +
        `YOUR findings (the "${mine.lens}" lens):\n${JSON.stringify(mine.findings, null, 2)}\n\n` +
        `THEIR findings (the "${theirs.lens}" lens), which you must assess:\n${JSON.stringify(theirs.findings, null, 2)}\n\n` +
        `For each, independently verify it against the tree and take a position: "confirm" (you checked, it holds), "refute" (you checked, it is wrong or the text is actually fine — say what they misread), or "amend" (real, but the severity or the proposed fix is wrong — give the corrected one).\n\n` +
        `Default to REFUTE when the evidence is thin. A finding that cannot be independently reproduced from the tree should not survive into the consensus. Do not confirm out of collegiality.\n\n` +
        `${READONLY}\n\n` +
        `Finally, in "missedByBoth", note anything their report made you realise you BOTH missed.`,
        { label: `cross:${g.tree.key}:${mine.key}`, phase: 'Cross-examine', model: 'fable', effort: 'high', schema: REBUTTAL_SCHEMA }
      ).then((r) => r && { by: mine.lens, tree: g.tree.key, ...r })
    })
  )
)

return { audits: live, rebuttals: rebuttals.filter(Boolean), unreconciled, degraded: unreconciled.length > 0 }
```

To iterate on the script, edit the file path the `Workflow` tool returns and
re-invoke with `{ scriptPath }` rather than resending it.

## Reach the consensus

The critics have already done the reconciling work — read it, don't redo it:

1. **Consensus findings** — raised by one critic and **confirmed** by the other.
   These are settled. Do not re-litigate them; carry them at the confirmed
   severity (or the amended one, if the cross-examiner amended and justified it).
2. **Refuted findings** — dropped. Report them as *raised and refuted* with the
   refutation's reasoning **and write them into
   [`knowledge/skill-improvement-log.md`](../../../knowledge/skill-improvement-log.md)
   as `· refuted` entries** (its five-field shape; the *Rationale* carries the
   tree evidence, the *Reconsider when* the condition that would revive the
   claim). **A refutation recorded only in a PR body does not exist**: the next
   audit greps `knowledge/`, finds nothing, and re-raises it cold — observed on
   2026-08-13, when a finding refuted in #444 came back on the very next run.
   Like every other edit, these entries are written in **Apply**, after the
   user's go-ahead — and they are worth writing even when the user declines
   every fix, because the memory is what stops the next run re-deriving them.
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
