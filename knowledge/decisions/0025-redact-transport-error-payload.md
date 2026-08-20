# ADR-0025: Redact the transport error carried by `TMDbError.network`

- **Status:** Accepted (in 20.0.0, unreleased)
- **Date:** 2026-08-20
- **Deciders:** Adam Young

## Context

`TMDbAPIClient` wraps a transport failure as `TMDbAPIError.network(error)`,
which [ADR-0001](0001-error-mapping-api-client.md)'s mapping seam turns 1:1 into
the public `TMDbError.network(_:)`. That associated error is precisely what a
consumer logs, ships to a crash reporter, or attaches as an analytics
breadcrumb.

On both Darwin and Linux a `URLSession` failure is an `NSError` whose `userInfo`
carries the **whole URL of the request that failed**, under `NSErrorFailingURLKey`
and `NSErrorFailingURLStringKey`. For a client built with `TMDbClient(apiKey:)`
that URL contains the `api_key` query item, and a user-scoped v3 request adds
`session_id`. So an ordinary timeout, DNS failure or dropped connection put the
caller's credential into their logs.

This contradicted a discipline the library had already committed to.
[ADR-0012](0012-structured-tmdberror-context.md) introduced
`EndpointPathRedactor` specifically so `TMDbErrorContext.endpointPath` would be
*safe to log* — it scrubs token-bearing **path** segments. Its own doc comment
disclaimed the query string, which was true of the value it is given and false
of the library as a whole: the library scrubbed a session id out of one case
while handing the API key over in the adjacent one. Issue #434.

## Decision

Redact at the single `.network(_:)` construction site
(`TMDbAPIClient.perform`), via a new internal `NetworkErrorRedactor`.

- **Read only the two documented failing-URL entries**, by key. Accept the
  `URL`/`NSURL` and `String`/`NSString` value forms, since Darwin stores the
  Objective-C types and a `URL`-only cast would match nothing — a fail-*open* no
  assertion about an absent credential could detect. The string key is spelled
  as a literal because the Foundation constant for it is deprecated and this
  package builds warnings-as-errors.
- **Redact by query-item *name*, not by matching the secret's value** —
  `api_key`, `session_id`, `request_token`, `guest_session_id`, compared
  lower-cased — and rewrite through `percentEncodedQueryItems`, because the
  plain accessor turns a literal `%2B` into `+` and would corrupt an unrelated
  `query=` beside the credential.
- **Redact token-bearing path segments too**, sharing one classifier with
  `EndpointPathRedactor` (`placeholder(forEndpoint:)`) so the two cannot drift.
  The failing URL is absolute, so the API version prefix is stripped first;
  without that the classifier sees `"3"` and the redaction is a silent no-op.
- **Rebuild `userInfo` from an allowlist**, not a scrubbed copy: the localized
  description keys verbatim plus the two redacted URL entries. Everything else
  is dropped.
- **Return the original error instance when nothing needed redacting.**
- Preserve `domain` and `code` on both paths.

## Consequences

- `TMDbError.network(_:)`'s payload is safe to log, and the library's redaction
  discipline now covers every credential it can put in a URL.
- **Breaking, and silently so** — nothing stops compiling. Consumers reading
  `NSUnderlyingError` or the related-task keys off a network error find them
  absent. Recorded prominently in `CHANGELOG.md` under 20.0.0.
- Diagnostics are lost from a *redacted* error only. An error with nothing to
  redact keeps everything.
- `domain`, `code` and `localizedDescription` are unchanged, so branching and
  display are unaffected; on Darwin the rebuilt error still bridges to
  `URLError`.
- A consumer-supplied `HTTPClient` throwing its own error type is unaffected:
  that error has no failing-URL entry, so the original instance is returned and
  `catch TMDbError.network(let error as MyTransportError)` keeps matching.
- The credential-name set is a new place to keep current. A TMDb endpoint that
  starts accepting a credential as some other query item needs a line here.

## Alternatives considered

- **Scrub every `userInfo` value that looks like a URL** — rejected, twice over.
  It cannot reach a credential nested inside `NSUnderlyingError` or the
  related-task array, so the "no unknown key can reintroduce the leak"
  justification is false; and "a `String` that parses as a URL" matches ordinary
  prose (`URL(string: "The request timed out.")` is non-nil), so writing the
  value back would percent-mangle the user-facing message. The allowlist is both
  safer and fewer branches.
- **Drop the URL entirely** — rejected: the host and endpoint are the most
  useful part of a transport failure, and they are not secret once the
  credential is out.
- **Always rebuild, unconditionally** — rejected: every Swift error bridges to
  `NSError`, so an unconditional rebuild erases a consumer error's concrete type
  and degrades its `localizedDescription` to Foundation's generic sentence.
  `HTTPClient` is a public, consumer-implementable protocol, so this is a real
  call path, not a hypothetical one.
- **Redact in `ErrorMappingAPIClient` instead** — rejected: it is the right
  choke point for *mapping*, but it sees an already-wrapped `TMDbAPIError`, and
  the redaction wants the raw transport error. The wrap site is one line earlier
  and equally singular.

## Related

- [ADR-0001](0001-error-mapping-api-client.md) — the mapping choke point this
  sits one layer beneath.
- [ADR-0012](0012-structured-tmdberror-context.md) — introduced
  `EndpointPathRedactor` and the "safe to log" commitment this extends.
- [ADR-0022](0022-reject-traversal-capable-path-segments.md) — the other
  credential-in-URL defence at the same client.
