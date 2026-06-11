---
name: diagnose-integration-failure
description: Diagnose a failing TMDb integration-test run — summarise the failure, rank the likely cause, and suggest a concrete fix
---

# Diagnose an integration-test failure

The TMDb integration tests hit the **live** TMDb API. This same suite gates
every PR and the merge to `main`, so a failure is **unlikely to be a code
regression** — a code bug would have been caught by the PR status check before
reaching this point. Diagnose accordingly.

> **Wrong suite?** If a **CI** check failed instead (lint, markdown, build, or
> unit tests from `ci.yml`), use `/diagnose-ci-failure`. That one leads with the
> opposite assumption: a CI failure is almost always caused by the change under
> review.

Produce a concise markdown analysis with exactly these three sections:

**Summary:** one or two sentences on what failed — name the failing
suite/test where visible.

**Likely cause:** the most probable root cause, ranked most-likely first. DO
NOT lead with "a code bug". Rank these:

1. **A TMDb backend change** — a response field was added, removed, renamed, or
   became nullable, breaking a model's `Decodable`. Confirm against the OpenAPI
   spec (see step 3).
2. **Stale assumed data in an integration test** — the test asserts a specific
   live value (a title, count, id, date, or ordering) that the API now returns
   differently. The code is fine; the test's baseline has drifted.
3. **A transient API error or rate limiting (HTTP 429).**

Cite the specific HTTP status codes, error messages, or failing assertions from
the log that point to your conclusion.

**Suggested fix:** the concrete next step — which Swift model or JSON fixture to
update for an API change, which integration-test assertion to relax or refresh
for drifted data, or (only for case 3) re-run the job / wait out rate limiting.

Keep it under ~150 words.

## Steps

1. **Locate the failure log**, in this order — use the first that exists:
   - A path the caller handed you (e.g. `failure-log.txt` in the working
     directory, used by the CI alert workflow).
   - `.build/last-integration-test.log` — written by the `/integration-test`
     skill. If you (or the user) haven't run the tests yet locally, run
     `/integration-test` first, then read this log.
   - Otherwise, find the failing run with the `gh` CLI:
     `gh run list --workflow Integration --status failure --limit 1` then
     `gh run view <id> --log-failed`.

2. **Read the failing portion** — focus on the assertion failures and error
   messages, which surface near the end. Read the specific test, model, and
   fixture files the log points to so your suggested fix names real symbols.

3. **Check the OpenAPI spec when the failure looks like a decode/shape error.**
   The live spec is the source of truth for the current response shape, but it
   is **~3 MB of minified JSON on a single line** — NEVER `grep`, `cat`, or
   `Read` it whole; that dumps the entire file into context. Extract only the
   one endpoint you need with `jq` (requires `jq`, which is present in CI and
   installable via Homebrew locally; if `jq` is unavailable, skip this step and
   say so):
   - Use `tmdb-openapi.json` in the working directory if present; otherwise
     fetch it (best-effort):
     `curl -fsSL --max-time 30 https://developer.themoviedb.org/openapi/tmdb-api.json -o tmdb-openapi.json`
   - The spec is OpenAPI 3.1 with response schemas **inlined per endpoint**
     (there is no reusable `components.schemas`). Find the endpoint, then pull
     just its 200-response schema:
     - List endpoints (cheap, ~5 KB): `jq -r '.paths | keys[]' tmdb-openapi.json`
     - Pull one schema (~5 KB): `jq '.paths."/3/movie/{movie_id}".get.responses."200".content."application/json".schema' tmdb-openapi.json`
       (swap in the path + HTTP method for the failing request)
     - Even cheaper, just the field names:
       `… .schema.properties | keys[]`
   - Compare the live schema against the failing model/fixture to confirm
     whether a field changed, became nullable, or was removed — then point at
     the specific Swift model or JSON fixture that needs updating.
   - If the spec can't be fetched or `jq` is unavailable, say so and proceed
     without it.

4. **Output the analysis.** If the caller asked you to write it to a file (e.g.
   `claude-analysis.md`), write the three-section markdown there and nothing
   else. Otherwise present it directly in your reply.
