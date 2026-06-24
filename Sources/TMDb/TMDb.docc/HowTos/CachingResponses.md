# Caching Responses

Avoid repeated network requests by reusing cached TMDb responses.

## Overview

TMDb data changes slowly, so the same request often returns the same result for
minutes or hours. To save bandwidth and time, the library can serve repeated
requests from a cache instead of hitting the network every time.

There are two independent caching layers:

| Layer | Storage | Default | TTL source | Platforms |
| ----- | ------- | ------- | ---------- | --------- |
| HTTP cache (`URLCache`) | On disk + memory | **On** | TMDb's `Cache-Control` headers | Apple platforms |
| Response cache (``CacheConfiguration``) | In memory | Off (opt-in) | Fixed value you configure | All platforms |

For most apps the on-disk HTTP cache is enough — it is already enabled and needs
no configuration. The in-memory cache is an optional extra layer on top.

## On-disk HTTP caching (enabled by default)

When you create a ``TMDbClient`` without supplying your own ``HTTPClient``, the
default `URLSession` adapter is configured with a
[`URLCache`](https://developer.apple.com/documentation/foundation/urlcache)
(50 MB in memory, 1 GB on disk) and the `.useProtocolCachePolicy` request policy:

```swift
// On-disk HTTP caching is active automatically — no configuration needed.
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")
```

TMDb serves its responses with standard HTTP caching headers — for example
`Cache-Control: public, max-age=18909` together with an `ETag`. `URLCache`
honours them, which gives you:

- **A response cache that persists across app launches**, stored on disk.
- **Per-resource freshness**, driven by each endpoint's own `max-age` — a movie
  stays fresh for hours, while `trending` is refreshed every few minutes.
- **Conditional revalidation**: once an entry goes stale, the next request sends
  the stored `ETag`. If nothing changed, TMDb replies `304 Not Modified` with an
  empty body, so the cached data is reused and almost no bandwidth is spent.

This layer is the simplest way to satisfy "don't make the same request twice",
and it is on unless you replace the HTTP client.

> Note: The on-disk `URLCache` is configured only on Apple platforms. On Linux
> and Windows the default adapter does not install a `URLCache`, so persistent
> HTTP caching is unavailable there — use the in-memory response cache below if
> you need caching on those platforms.

## In-memory response caching (opt-in)

Enable ``CacheConfiguration`` on ``TMDbConfiguration`` to add a second cache
layer that stores successful `GET` responses **in memory**, above the HTTP
client. It uses a single fixed time-to-live that you choose, rather than TMDb's
per-response `max-age`:

```swift
// Default: 1-hour TTL, up to 100 entries.
let configuration = TMDbConfiguration(cache: .default)
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>", configuration: configuration)
```

Customise the time-to-live and capacity:

```swift
let cacheConfig = CacheConfiguration(
    defaultTTL: .seconds(1800),    // 30-minute TTL
    maximumEntryCount: 200
)

let configuration = TMDbConfiguration(cache: cacheConfig)
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>", configuration: configuration)
```

This layer is deliberately lightweight: it holds responses in memory only (so it
is cleared when the process ends), caches `GET` requests only, bypasses
user-specific requests (those carrying a `session_id` or a guest session), and
invalidates the entire cache after any successful `POST` or `DELETE`.

Reach for it when you want a predictable, fixed TTL regardless of TMDb's headers,
or when you need a cache on a platform where `URLCache` is unavailable.

## How the layers interact

A request flows outward-in through whichever layers are enabled:

```text
in-memory response cache  ->  automatic retry  ->  URLSession / URLCache (disk)
   (opt-in CacheConfiguration)   (opt-in RetryConfiguration)   (default on Apple platforms)
```

A hit in the in-memory cache short-circuits everything below it — no retry, no
network, no `URLCache` lookup. On a miss, the request continues down to
`URLCache`, which serves the response from disk if it is still fresh (or
revalidates it with an `ETag`) before any real network traffic happens. The two
caches are complementary: `URLCache` gives you persistence and per-resource
freshness for free, and the in-memory cache adds a fast, fixed-TTL layer when you
want one. See <doc:HandlingErrors> for how caching affects the errors you see.

## Tuning or disabling the on-disk cache

The built-in `URLSession` adapter is not exposed, so to change or switch off the
default `URLCache` you supply your own ``HTTPClient`` backed by a `URLSession`
you configure (see <doc:CreatingTMDbClient>). Set a smaller `URLCache`, point it
at your own directory, or set it to `nil` to disable on-disk caching entirely:

```swift
import Foundation
import TMDb

struct CustomHTTPClient: HTTPClient {

    private let urlSession: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        // Resize the on-disk cache...
        configuration.urlCache = URLCache(memoryCapacity: 10_000_000, diskCapacity: 200_000_000)
        // ...or set `configuration.urlCache = nil` to disable HTTP caching.
        urlSession = URLSession(configuration: configuration)
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        for (field, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }

        let (data, response) = try await urlSession.data(for: urlRequest)
        let httpResponse = response as? HTTPURLResponse
        let statusCode = httpResponse?.statusCode ?? 0
        // Forward the headers so features like Retry-After backoff keep working.
        let headers = Dictionary(
            uniqueKeysWithValues: (httpResponse?.allHeaderFields ?? [:]).compactMap {
                key, value in (key as? String).map { ($0, "\(value)") }
            }
        )
        return HTTPResponse(statusCode: statusCode, data: data, headers: headers)
    }

}

let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>", httpClient: CustomHTTPClient())
```

To turn off all caching, disable both layers: pass an `HTTPClient` whose
`URLCache` is `nil` (or use `.reloadIgnoringLocalCacheData`) and leave
``TMDbConfiguration/cache`` unset.

## See Also

- <doc:CreatingTMDbClient>
- <doc:HandlingErrors>
- ``CacheConfiguration``
