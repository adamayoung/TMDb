---
name: review-pr-threads
description: Resolve the currently-unresolved review threads on the current branch's PR in one sweep — assess each, fix it (test-first, verified) or reply-only, then reply and resolve — and return a summary. Use standalone to address PR review feedback, or as the thread-handling step invoked by /watch-pr. Repo is adamayoung/TMDb.
---

# Review PR Threads

Handle the open **review conversations** on a pull request: for each unresolved
thread, decide whether it warrants a code change, make and verify the fix (or
explain why not), reply, and resolve it. This is a **single sweep** over the
threads that are unresolved *right now* — it does not wait for new reviews to
arrive. The caller (you, or `/watch-pr`) decides whether to run it again after a
push triggers a fresh review.

Repo is `adamayoung/TMDb`. GitHub reads (find the PR, fetch threads) and the
**resolve** use the **GitHub MCP** (`mcp__github__*`); the thread **reply** stays on
`gh api graphql` — the MCP reply tool needs a numeric REST comment id that the thread
read doesn't expose, whereas the GraphQL reply takes the thread node id we already
have. `gh` is authenticated.

## Principles

1. **One sweep, then return.** Process every thread that is unresolved at
   invocation, then stop and report. Do not loop waiting for re-reviews — pushing
   a fix re-triggers the `claude-review` bot and CI, and that convergence loop
   belongs to the caller.
2. **Fix test-first and verify before you reply.** A code change in response to a
   thread follows the project's discipline: reproduce/capture with a test where
   applicable, then fix, then verify with the delegated skills. Never claim a fix
   you haven't verified.
3. **Don't change code you disagree with — reply instead.** Out-of-scope,
   incorrect, already-handled, or question-only threads get a reasoned reply and a
   resolve, not an edit.
4. **Dedup via the run ledger.** Keep (or reuse the caller's) ledger of handled
   thread IDs and a topic signature (`path:line` + gist) per thread. If a thread
   repeats a topic you already fixed this run, reply pointing at the earlier commit
   SHA and resolve — do **not** re-edit.
5. **The `claude-review` bot's summary comment is advisory.** It posts inline
   threads only for Critical/High; its Medium/Low summary bullets are not threads
   and are not work items — don't turn them into code changes.

## 0. Find the PR

Find the open PR for the current branch with `mcp__github__list_pull_requests`
(owner/repo from the `origin` remote, `head: <owner>:<branch>`, `state: open`), or
read a specific one with `mcp__github__pull_request_read` method `get`
(`pullNumber: <n>`). Take `number`/`html_url`/`state`/`head.ref` from the result.

- An explicit PR number in the skill arguments overrides the current branch.
- No PR for the current branch → stop and tell the user (suggest `/pr`).
- State not `open` → stop and report.

## 1. Fetch unresolved threads

Use `mcp__github__pull_request_read` method `get_review_comments` (owner/repo from
`origin`, `pullNumber: <n>`). It returns review **threads**, each with metadata
(`isResolved`, `isOutdated`, `isCollapsed`), the thread **node id** (`PRRT_…`, used to
resolve in §2), `path`/`line`, and the grouped comments. Paginate with
`perPage`/`after` (the `endCursor` from the previous page's `pageInfo`) if needed.

Process each thread where `isResolved` is `false` and whose thread id is not already
in the ledger.

## 2. Handle each thread

For each unresolved thread:

1. **Assess** the comment(s) and decide whether a code change is warranted, in
   scope, and clearly correct.
2. **Needs a fix** → edit the code, then verify with the delegated skills —
   `/lint`, `/build`, `/test` (and `/integration-test` if it could affect live-API
   behaviour); those run in Haiku subagents so logs stay out of context. Commit
   with a gitmoji message and record the commit SHA. **Batch the sweep's pushes:**
   commit per fix, but `git push` **once** after all threads are handled (§3), so
   one review/CI cycle is triggered per sweep, not one per thread.
3. **No fix warranted** (disagree / out of scope / a question / already done) →
   make no code change; you'll say why in the reply.
4. **Reply** on the thread — what you assessed and whether you fixed it (include
   the commit SHA when you did). This step stays on `gh api graphql`: the GraphQL
   reply takes the thread **node id** (`PRRT_…`) we already have from §1, whereas the
   MCP `add_reply_to_pull_request_comment` needs a numeric REST comment id that
   `get_review_comments` doesn't return.

   ```bash
   gh api graphql -f query='mutation($id:ID!,$body:String!){
     addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$id,body:$body}){ comment{ id } }
   }' -f id=<THREAD_ID> -f body='<your feedback>'
   ```

5. **Resolve** the thread with `mcp__github__pull_request_review_write` method
   `resolve_thread` (`threadId: <PRRT_… node id>`; `owner`/`repo`/`pullNumber` are
   ignored for this method). Resolving an already-resolved thread is a no-op.

6. Record the thread ID and topic signature in the ledger.

> Reply and resolve **after** the single push (§3) for threads you fixed, so the
> SHA you cite is on the remote. Reply/resolve reply-only threads immediately.

## 3. Push once, then finish

After every thread is handled, if you committed any fixes, `git push` once (it
re-triggers CI and the `claude-review` bot — expected). Then post the deferred
replies + resolves for the fixed threads.

Every commit fires the pre-commit `make lint` hook; fix lint before retrying.

## Guardrails

- Never edit `.github/workflows/*` or other CI/config to silence a reviewer, and
  never force-push, without surfacing to the user first.
- If a requested change is ambiguous or risky, reply with your assessment and
  leave it for the user (note it in the summary) rather than guessing.
- Stay in scope: address the thread, don't opportunistically refactor around it.

## Return: sweep summary

Report, concisely:

- **Fixed** — thread topic → commit SHA, per fixed thread.
- **Replied-only** — thread topic → one-line reason (disagreed / out of scope /
  already done / question answered).
- **Left for the user** — ambiguous/risky threads you replied on but did not act
  on, and why.
- **Counts** — threads handled this sweep, and any that remain unresolved (e.g.
  a thread you intentionally left open for a human decision).

Whether anything was pushed (and the resulting CI/review re-trigger) so the caller
can decide whether to sweep again.

Arguments: $ARGUMENTS
