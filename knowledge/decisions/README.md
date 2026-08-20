# Architecture Decision Records

One file per non-obvious design decision, with its rationale. Start from
[`0000-template.md`](0000-template.md).

**Numbering:** the next ADR takes the number after the highest in the table below
— check the table, not a directory listing, before naming a file. (Two ADRs were
once both numbered `0010`; the model-tier one was renumbered to `0014` by the
2026-07-28 audit. This index exists so that cannot recur.)

**Immutability:** an `Accepted` ADR is not edited to reflect a later change of
mind — write a new one and mark the old **Superseded by [ADR-XXXX]**, with a
forward link in the superseded file and a back link in the new one. Correcting a
factual error, a stale status, or a broken link is *not* a change of mind and is
always fair game.

## Index

| # | Decision | Date | Status |
| --- | --- | --- | --- |
| [0001](0001-error-mapping-api-client.md) | Centralise API error mapping in an `ErrorMappingAPIClient` decorator | 2024 | Accepted (shipped in 18.0.0) |
| [0002](0002-changes-auto-pagination-adapter.md) | Auto-pagination for Changes adapts `ChangedIDCollection`, excludes detail endpoints | 2026-06-18 | Accepted |
| [0003](0003-opt-in-pagination-prefetch.md) | Opt-in next-page prefetch holds an unstructured `Task` on a value-type iterator | 2026-06-18 | Accepted |
| [0004](0004-service-parameter-name-convention.md) | Service method parameter-name convention (`<entity>ID`) | 2026-06-18 | Accepted |
| [0005](0005-authenticated-session-additive-overloads.md) | `AuthenticatedSession` via additive extension overloads | 2026-06-18 | Accepted |
| [0006](0006-tmdbtesting-public-target.md) | Ship a public `TMDbTesting` target (spy+stub mocks + real-data samples) | 2026-06-23 | Accepted (amended in part by [0010](0010-tmdb-intelligence-product.md)) |
| [0007](0007-document-existing-response-caching.md) | Document existing response caching instead of building a custom on-disk cache | 2026-06-24 | Accepted |
| [0008](0008-percent-encode-url-path-segments.md) | Percent-encode user-supplied URL path segments with the RFC 3986 unreserved set | 2026-06-24 | Accepted (amended in part by [0022](0022-reject-traversal-capable-path-segments.md)) |
| [0009](0009-github-mcp-over-gh-cli.md) | Use the GitHub MCP (not the `gh` CLI) in the local skills | 2026-06-25 | Accepted |
| [0010](0010-tmdb-intelligence-product.md) | Extract on-device intelligence into a `TMDbIntelligence` product | 2026-07-06 | Accepted (shipped in 19.0.0) |
| [0011](0011-duration-for-runtime.md) | Represent runtimes as `Duration`, bridging integer minutes at the wire boundary | 2026-07-24 | Accepted (shipped in 19.0.0) |
| [0012](0012-structured-tmdberror-context.md) | Enrich `TMDbError` with structured context | 2026-07-24 | Accepted (shipped in 19.0.0) |
| [0013](0013-cached-image-url-resolver.md) | Cache the image configuration in an actor behind `client.images` | 2026-07-27 | Accepted (shipped in 19.0.0; one consequence superseded by [0018](0018-cancellation-as-tmdberror-case.md)) |
| [0014](0014-subagent-model-tiers.md) | Model-tier policy for skills and subagents | 2026-07-06 | Accepted (amended in part by [0020](0020-review-knowledge-audit-tier.md)) |
| [0015](0015-durable-deliver-run-state.md) | Durable `/deliver` run state in `.git/deliver/` | 2026-07-29 | Accepted (unreleased — tooling only) |
| [0016](0016-panel-jurors-and-workflows-directory.md) | Auto-mode panel as three independent jurors, in `.claude/workflows/` | 2026-07-29 | Accepted (unreleased — tooling only) |
| [0017](0017-v4-api-client.md) | A third `TMDbAPIClient` instance for the v4 API | 2026-08-07 | Accepted (in 20.0.0, unreleased) |
| [0018](0018-cancellation-as-tmdberror-case.md) | Surface task cancellation as `TMDbError.cancelled` | 2026-08-12 | Accepted (in 20.0.0, unreleased) |
| [0019](0019-decode-tolerance-policy.md) | One decode-tolerance policy: skip an unmodelled `media_type`, stay loud otherwise | 2026-08-12 | Accepted (in 20.0.0, unreleased) |
| [0020](0020-review-knowledge-audit-tier.md) | `/review-knowledge` audits on Opus; cross-examination stays on Fable | 2026-08-13 | Accepted (unreleased — tooling only) |
| [0021](0021-extensible-public-vocabularies.md) | Three shapes for a growable public vocabulary | 2026-08-13 | Accepted (in 20.0.0, unreleased) |
| [0022](0022-reject-traversal-capable-path-segments.md) | Reject traversal-capable path segments at the `TMDbAPIClient` choke point | 2026-08-13 | Accepted (in 20.0.0, unreleased) |
| [0023](0023-python-strict-parser-for-fixture-hygiene.md) | Enforce fixture hygiene with an independent strict parser, not a Swift test | 2026-08-14 | Accepted (unreleased — tooling only) |
| [0024](0024-two-way-witness-guard.md) | Keep the defaulted-witness guard, as a two-way completeness oracle | 2026-08-14 | Accepted (in 20.0.0, unreleased) |
| [0025](0025-redact-transport-error-payload.md) | Redact the transport error carried by `TMDbError.network` | 2026-08-20 | Accepted (in 20.0.0, unreleased) |
| [0026](0026-unattended-selection-needs-an-author-check.md) | An unattended run must not read its authorisation from the work it selected | 2026-08-20 | Accepted (unreleased — tooling only) |

> **Keep the Status column true.** "In X, unreleased" becomes "shipped in X" when
> X is **tagged** — a `CHANGELOG.md` section is not a release. For breaking changes
> still waiting on a major bump, see [`../next-major.md`](../next-major.md), which
> the release process reads.
