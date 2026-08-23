# Understanding the TMDb API

> Topic doc referenced from [`CLAUDE.md`](../../CLAUDE.md). Read before any
> work shaped by the live API — new endpoints, model changes, fixtures, or
> probe scripts.

## OpenAPI Specification

The complete API spec is at:
**<https://developer.themoviedb.org/openapi/tmdb-api.json>**

Use this to understand endpoints, request/response schemas, query
parameters, and authentication requirements.

## TMDb MCP Server

**ALWAYS use the TMDb MCP server** (`mcp__tmdb__*` tools) to query the
live API instead of making assumptions about response structures. Use it
for:

- **Exploring API responses** — fetch real data to understand structure
- **Creating JSON fixtures** — get actual API responses for test fixtures
- **Verifying endpoint behaviour** — check nullable/missing fields

## Workflow for New Endpoints

1. Check the OpenAPI spec for endpoint structure and parameters
2. Use MCP to fetch real data (e.g., `mcp__tmdb__movie_details`)
3. Examine the actual JSON response structure
4. **Sample the population before deciding optionality — don't spot-check.**
   One record tells you what *that* record has. Pull tens of records and build a
   field/nullability matrix: #404 nearly shipped a one-field fix because a
   single `curl` looked conclusive, and 54 companies showed a second field had
   the same bug; #432's 300-record sweep both cleared five decodes *and* found a
   bug the issue never mentioned. A sweep earns its keep by **excluding** as
   much as by finding — a measured "we checked, it isn't in the class" survives
   review; "the API probably never sends that" doesn't.
5. Create models based on real data, not assumptions
6. Save response as JSON fixture in `Tests/TMDbTests/Resources/json/`
7. Implement the feature

## Probe Scripts Must Verify Their Own Postcondition

Live-API probing is how this repo establishes truth, but the scripts doing it
get none of the rigour the Swift does, and two of #411's three bugs *were the
probe lying*: a cleanup `EXIT` trap that never fired and orphaned four lists on
a real account, and a uniform "rejected" result across a parameter sweep that
was the spam filter (`status_code` 18), not an answer. So: end a probe by
asserting the state it claims to have left — enumerate and confirm the cleanup
happened — and treat a **uniform** result across a sweep as evidence about the
*sweep* until the error body says otherwise.
