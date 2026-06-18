# Handling Errors

Understand the errors TMDb throws and recover from them gracefully.

## Overview

Every asynchronous method on a TMDb service is typed to throw
``TMDbError``. For example, ``MovieService/details(forMovie:language:)`` is
declared `async throws(TMDbError)`, so the concrete error type is known at
the call site — there is no need to cast from a generic `Error`.

``TMDbError`` conforms to
[`LocalizedError`](https://developer.apple.com/documentation/foundation/localizederror),
so `error.localizedDescription` returns a human-readable message for every
case.

## Error Cases

``TMDbError`` enumerates the failures you can encounter:

| Case | When it occurs |
| ---- | -------------- |
| ``TMDbError/badRequest(_:)`` | The request was malformed or rejected by the API (HTTP 400, 405, 406, 422), or a URL could not be built. |
| ``TMDbError/unauthorised(_:)`` | Authentication failed (HTTP 401) — usually a missing or invalid API key, or an expired session. |
| ``TMDbError/forbidden(_:)`` | The API key is valid but not permitted to access the resource (HTTP 403). |
| ``TMDbError/notFound(_:)`` | The requested resource does not exist (HTTP 404). |
| ``TMDbError/tooManyRequests(_:)`` | The API rate limit was exceeded (HTTP 429). |
| ``TMDbError/serverError(_:)`` | TMDb reported a server-side failure (HTTP 5xx). |
| ``TMDbError/network(_:)`` | The request never completed — offline, timed out, or a DNS / connection failure. The underlying error is attached. |
| ``TMDbError/decode(_:)`` | A response was received but could not be decoded into the expected model. The underlying error is attached. |
| ``TMDbError/invalidRating`` | A rating passed to an `addRating` method is out of range; it must be between `0.5` and `10.0` in increments of `0.5`. Validated on-device before any request is sent. |
| ``TMDbError/unknown`` | An unexpected error that does not map to any of the above. |

## Catching Errors

Use a `do` / `catch` and switch on the cases you want to handle specially,
falling back to `localizedDescription` for the rest:

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

do {
    let movie = try await tmdbClient.movies.details(forMovie: 550)
    print(movie.title)
} catch TMDbError.notFound {
    print("That movie doesn't exist.")
} catch TMDbError.unauthorised {
    print("Check your API key.")
} catch TMDbError.tooManyRequests {
    print("Rate limited — try again shortly.")
} catch TMDbError.network(let underlying) {
    print("Network problem: \(underlying.localizedDescription)")
} catch TMDbError.decode {
    print("The response couldn't be read.")
} catch {
    print("Something went wrong: \(error.localizedDescription)")
}
```

Because the service methods use typed throws, the `catch` clauses match
``TMDbError`` cases directly, and the final `catch` handles any case you did
not name explicitly.

## Interaction with Retry and Caching

When you enable automatic retry (see <doc:CreatingTMDbClient>), TMDb
transparently retries transient failures — rate limiting (HTTP 429), server
errors (HTTP 5xx), and network errors — with exponential backoff, but **only
for idempotent requests** (`GET` and `DELETE`). A non-idempotent `POST` (such
as adding a rating) is never retried, so it is performed at most once.

Retry is invisible to your `catch` blocks: an error is thrown only once the
retries are exhausted. A request that stays rate-limited on every attempt, for
instance, surfaces as ``TMDbError/tooManyRequests(_:)`` after the final
attempt — you never see the intermediate failures.

When response caching is enabled, a cache hit short-circuits the request
entirely: the stored response is returned without touching the network or the
retry logic, so a cached read cannot produce a network or rate-limit error.

## See Also

- <doc:CreatingTMDbClient>
