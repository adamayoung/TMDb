---
name: watch-pr
description: Watch the current branch's PR — reply to and resolve review threads, fix failing checks, and optionally merge when ready
---

# Watch PR

Watch the open pull request for the current branch: handle review conversations,
fix failing status checks, and — when asked — merge once everything is green.
Repo is `adamayoung/TMDb`; `gh` is authenticated.

**Mode** — check the arguments passed to this skill (shown at the end). If they
include `merge` (e.g. `/watch-pr merge` or "merge when ready"), enable
**merge-when-ready**; otherwise run in **watch-only** mode.

## 0. Find the PR

```bash
gh pr view --json number,url,state,headRefName,mergeStateStatus,statusCheckRollup,reviewDecision
```

- No PR for the current branch → stop and tell the user (suggest `/pr`).
- State not `OPEN` → stop and report.

Keep a **run ledger** in your working notes: resolved thread IDs, a topic
signature per handled thread (`path:line` + short gist), and a fix-attempt
counter per failing check. Use it to avoid repeating work (see Loop Guard).

## 1. Watch loop

Repeat the pass below until the PR is **ready** (§3) or **stuck** (§2).

### 1a. Review threads

Fetch unresolved threads (use the PR number from step 0):

```bash
gh api graphql -f query='
query($owner:String!,$name:String!,$number:Int!){
  repository(owner:$owner,name:$name){
    pullRequest(number:$number){
      reviewThreads(first:100){
        nodes{
          id isResolved isOutdated path line
          comments(first:50){ nodes{ author{login} body createdAt } }
        }
      }
    }
  }
}' -f owner=adamayoung -f name=TMDb -F number=<NUMBER>
```

For each thread where `isResolved` is `false` and whose `id` is not already in
the ledger:

1. Read the comment(s) and decide whether a code change is warranted.
2. **Needs a fix** (clear and in scope): edit the code, then verify with the
   delegated skills — `/lint`, `/build`, `/test` (and `/integration-test` if the
   change could affect live-API behaviour). Those run in Haiku subagents, so
   their output stays out of your context. Commit with a gitmoji message and
   `git push`. Note the commit SHA.
3. **No fix warranted** (you disagree, out of scope, it's a question, or already
   done): make no code change — you'll explain in the reply.
4. **Reply** on the thread with your feedback: what you assessed and whether you
   fixed it (include the commit SHA when you did):

   ```bash
   gh api graphql -f query='mutation($id:ID!,$body:String!){
     addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$id,body:$body}){ comment{ id } }
   }' -f id=<THREAD_ID> -f body='<your feedback>'
   ```

5. **Resolve** the thread:

   ```bash
   gh api graphql -f query='mutation($id:ID!){
     resolveReviewThread(input:{threadId:$id}){ thread{ isResolved } }
   }' -f id=<THREAD_ID>
   ```

6. Record the thread ID and its topic signature in the ledger.

### 1b. Status checks

```bash
gh pr checks --json name,state,bucket,link
```

Classify by `bucket`: `fail` = failing, `pending` = in progress, `pass` /
`skipping` = fine. `claude-review` and other neutral checks are non-blocking.
While anything is pending, block efficiently with `gh pr checks --watch` rather
than polling in a tight loop.

For each **failing** check, delegate log retrieval to a **Haiku subagent** so raw
CI logs never enter your context. Use the Agent tool with
`subagent_type: general-purpose` and `model: haiku` and this prompt:

```text
Find why the `<CHECK NAME>` check failed on the TMDb PR for branch `<branch>`
and report concisely.

1. Run `gh run list --branch <branch> --limit 5 --json databaseId,name,conclusion`
   to find the failed run id.
2. Run `gh run view <id> --log-failed`.

Report back ONLY:
- The failing job/step
- The root cause
- The offending `file:line` and message (if any)

Do not paste raw logs.
```

Then fix the issue, verify locally with the matching delegated skill (`/lint`,
`/build`, `/test`, `/integration-test`), commit (gitmoji), and `git push` — the
push re-triggers CI. Increment that check's attempt counter.

## 2. Loop guard (do not get stuck)

- Never reprocess a thread already in the ledger.
- If a **new** thread repeats a topic you already fixed this run, do **not**
  re-edit — reply pointing to the earlier commit SHA and resolve it.
- A failing check gets at most **3** fix→push attempts. If it still fails with
  the same root cause, **stop** and report it to the user — never loop forever.
- End the loop when a full pass resolves no new threads and has no actionable
  check failures. Hard backstop: ~10 passes, then report and stop.
- Waiting: use `gh pr checks --watch` for in-flight CI. When only waiting on a
  human to review, pause and resume later with `ScheduleWakeup` (a few minutes
  while CI is active; longer when idle). This skill also composes with `/loop`
  if the user prefers harness-driven cadence.

## 3. Ready / merge

The PR is **ready** when every review thread is resolved AND no check is failing
or pending.

- **Watch-only**: report "PR is ready" with a short summary (threads handled,
  checks green) and stop.
- **Merge-when-ready**: on ready, merge and clean up, then report the result:

  ```bash
  gh pr merge --squash --delete-branch
  ```

## Guardrails

- Never edit `.github/workflows/*` or other CI/config to force a check green, and
  never force-push, without surfacing to the user first.
- If a requested change is ambiguous or risky, reply on the thread with your
  assessment and leave it for the user (note it in the final summary) rather than
  guessing.
- Every commit fires the pre-commit `make lint` hook; fix lint before retrying.

Arguments: $ARGUMENTS
