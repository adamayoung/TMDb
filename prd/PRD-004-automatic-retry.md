# PRD-004: Automatic Retry with Exponential Backoff

| Field    | Value                                  |
|----------|----------------------------------------|
| Priority | Medium                                 |
| Effort   | Small                                  |
| Status   | Done                                   |

## Problem Statement

The TMDb API enforces rate limits, returning HTTP 429 (Too Many
Requests) with a `Retry-After` header when the limit is exceeded.
Transient server errors (5xx) can also occur.

The package already defines `TMDbError.tooManyRequests` and
`TMDbAPIError.tooManyRequests`, but these errors are passed directly
to consumers with no automatic recovery. Every consumer must
implement their own retry logic or risk failing on transient issues.

This is especially problematic when:

- Iterating through many pages (see PRD-003)
- Making multiple append-to-response calls in quick succession
- Using the library in batch processing or CI pipelines

## Proposed Solution

Add a configurable retry layer to the networking stack that
automatically retries failed requests with exponential backoff for
retryable errors (429 and 5xx).

### Usage

Retry is configured via `TMDbConfiguration`:

```swift
let client = TMDbClient(
    apiKey: "...",
    configuration: TMDbConfiguration(
        retry: RetryConfiguration(
            maxRetries: 3,
            initialDelay: .seconds(1),
            maxDelay: .seconds(30),
            retryableErrors: [.rateLimit, .serverErrors]
        )
    )
)
```

Or disabled (default behaviour, preserving backwards compatibility):

```swift
// Default — no retry, same as current behaviour
let client = TMDbClient(apiKey: "...")
```

### Retry Behaviour

1. Request fails with a retryable error
2. If `Retry-After` header is present, use that delay
3. Otherwise, use exponential backoff: `min(initialDelay * 2^attempt,
   maxDelay)` with jitter
4. Wait, then retry
5. After `maxRetries` attempts, throw the original error

## Technical Design

### Architecture

The retry logic is implemented as a decorator around `HTTPClient`,
keeping the networking layer composable:

```text
TMDbAPIClient
    ↓
RetryHTTPClient (new — decorator)
    ↓
URLSessionHTTPClientAdapter
```

The `HTTPClient` protocol already conforms to `Sendable`, so the
decorator is safe to mark `Sendable`:

```swift
/// An HTTP client that retries failed requests with exponential
/// backoff.
final class RetryHTTPClient: HTTPClient, Sendable {

    private let wrapped: HTTPClient
    private let configuration: RetryConfiguration

    init(wrapping client: HTTPClient,
         configuration: RetryConfiguration) {
        self.wrapped = client
        self.configuration = configuration
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        var lastError: Error?
        var lastRetryAfter: Duration?

        for attempt in 0...configuration.maxRetries {
            if attempt > 0 {
                let delay = self.delay(
                    for: attempt,
                    retryAfter: lastRetryAfter
                )
                try await Task.sleep(for: delay)
            }

            do {
                let response = try await wrapped.perform(
                    request: request
                )

                // Check for retryable status codes on the response
                if isRetryableStatusCode(response.statusCode) {
                    lastRetryAfter = response.retryAfterDuration
                    lastError = TMDbAPIError.tooManyRequests(nil)
                    continue
                }

                return response
            } catch {
                guard isRetryable(error) else { throw error }
                lastError = error
                lastRetryAfter = nil
            }
        }

        guard let lastError else { throw CancellationError() }
        throw lastError
    }

    private func isRetryableStatusCode(_ statusCode: Int) -> Bool {
        if configuration.retryableErrors.contains(.rateLimit),
           statusCode == 429 {
            return true
        }
        if configuration.retryableErrors.contains(.serverErrors),
           (500...599).contains(statusCode) {
            return true
        }
        return false
    }

    private func isRetryable(_ error: Error) -> Bool {
        // Only retry errors that are already mapped to retryable
        // categories. Network-level errors (timeouts, connection
        // resets) are NOT retried — they propagate immediately.
        // This keeps the retry scope narrow and predictable.
        if let tmdbError = error as? TMDbAPIError {
            switch tmdbError {
            case .tooManyRequests:
                return configuration.retryableErrors
                    .contains(.rateLimit)
            case .internalServerError, .serviceUnavailable:
                return configuration.retryableErrors
                    .contains(.serverErrors)
            default:
                return false
            }
        }
        return false
    }
}
```

**Note:** The retry client operates on raw `HTTPResponse` objects
(Option A from below), checking `statusCode` directly rather than
waiting for errors. This means `HTTPResponse` must include a
`retryAfterDuration` computed property that parses the `Retry-After`
header (see "Files to Modify" below).

### Configuration Model

```swift
/// Configuration for automatic request retry.
public struct RetryConfiguration: Hashable, Sendable {

    /// Maximum number of retry attempts (not including the initial
    /// request). Default: 3.
    public let maxRetries: Int

    /// Initial delay before the first retry. Default: 1 second.
    public let initialDelay: Duration

    /// Maximum delay between retries. Default: 30 seconds.
    public let maxDelay: Duration

    /// Which errors are eligible for retry.
    public let retryableErrors: RetryableErrors

    /// Creates a retry configuration.
    public init(
        maxRetries: Int = 3,
        initialDelay: Duration = .seconds(1),
        maxDelay: Duration = .seconds(30),
        retryableErrors: RetryableErrors = [.rateLimit, .serverErrors]
    ) { ... }

    /// Predefined retry configuration with default values.
    public static let `default` = RetryConfiguration()
}

/// Error categories eligible for retry.
public struct RetryableErrors: OptionSet, Hashable, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    /// Retry on HTTP 429 (Too Many Requests).
    public static let rateLimit = RetryableErrors(rawValue: 1 << 0)

    /// Retry on HTTP 5xx (Server Errors).
    public static let serverErrors = RetryableErrors(rawValue: 1 << 1)
}
```

### Delay Calculation

```swift
private func delay(for attempt: Int,
                   retryAfter: Duration?) -> Duration {
    // Prefer Retry-After header if present
    if let retryAfter { return retryAfter }

    // Exponential backoff with full jitter
    // Duration supports integer multiplication, so compute the
    // multiplier as Int (1, 2, 4, 8, ...) via bit shifting.
    let multiplier = 1 << (attempt - 1)
    let exponential = configuration.initialDelay * multiplier
    let capped = min(exponential, configuration.maxDelay)
    let cappedSeconds = Double(capped.components.seconds)
        + Double(capped.components.attoseconds) / 1e18
    let jitter = Duration.seconds(
        Double.random(in: 0...cappedSeconds)
    )
    return jitter
}
```

### `Retry-After` Header

The TMDb API includes a `Retry-After` header on 429 responses
(value in seconds as an integer string, e.g., `"2"`). The retry layer
parses this from the `HTTPResponse` headers when available. Only the
`delta-seconds` format needs to be supported — the TMDb API does not
use the HTTP-date format.

This requires `HTTPResponse` to include response headers (currently
it only has `statusCode` and `data`). The `RetryHTTPClient` sits
between `TMDbAPIClient` and `URLSessionHTTPClientAdapter` in the
stack, operating on raw `HTTPResponse` objects so it can check
status codes and headers before errors are raised:

```text
TMDbAPIClient
    ↓
RetryHTTPClient (checks statusCode + Retry-After header)
    ↓
URLSessionHTTPClientAdapter (populates headers from HTTPURLResponse)
```

### Integration With `TMDbConfiguration`

Add a `retry` property to the existing configuration struct:

```swift
// Sources/TMDb/TMDbConfiguration.swift
public struct TMDbConfiguration: Sendable, Equatable {
    public let defaultLanguage: String?
    public let defaultCountry: String?
    public let retry: RetryConfiguration?  // New — nil means no retry

    public init(
        defaultLanguage: String? = nil,
        defaultCountry: String? = nil,
        retry: RetryConfiguration? = nil
    ) { ... }
}
```

**`Equatable` conformance:** `TMDbConfiguration` conforms to
`Equatable`. Since `RetryConfiguration` is added as a property,
it must also conform to `Equatable`. `Duration` already conforms
to `Equatable`, so this works automatically via the `Hashable`
conformance declared on `RetryConfiguration`.

### Cancellation

Retry respects structured concurrency. `Task.sleep(for:)` throws
`CancellationError` if the task is cancelled, stopping the retry
loop immediately.

### Files to Create

| File | Purpose |
|------|---------|
| `Sources/TMDb/Networking/RetryHTTPClient.swift` | Retry decorator |
| `Sources/TMDb/Domain/Models/RetryConfiguration.swift` | Configuration model |
| `Sources/TMDb/Domain/Models/RetryableErrors.swift` | Error category option set |

### Files to Modify

| File | Change |
|------|--------|
| `Sources/TMDb/TMDbConfiguration.swift` | Add `retry` property |
| `Sources/TMDb/TMDbFactory.swift` | Wrap HTTP client with `RetryHTTPClient` when configured |
| `Sources/TMDb/TMDbClient.swift` | Pass configuration through |
| `Sources/TMDb/Networking/HTTPClient/HTTPResponse.swift` | Add `headers: [String: String]` property and `retryAfterDuration` computed property. **Note:** `HTTPResponse` is `public` — adding `headers` to `init` changes the public initializer signature. Add `headers` with a default value (`headers: [String: String] = [:]`) to maintain backwards compatibility. |
| `Sources/TMDb/Networking/HTTPClient/URLSessionHTTPClientAdapter.swift` | Populate `headers` from `HTTPURLResponse.allHeaderFields` |
| `Sources/TMDb/TMDb.docc/TMDb.md` | Add `RetryConfiguration` to topic sections |
| `Sources/TMDb/TMDb.docc/GettingStarted/` | Document retry configuration usage |
| `README.md` | Document retry capability |

### Test Files to Create

| File | Purpose |
|------|---------|
| `Tests/TMDbTests/Networking/RetryHTTPClientTests.swift` | Unit tests for retry count, delay, error propagation, cancellation |
| `Tests/TMDbTests/Domain/Models/RetryConfigurationTests.swift` | Unit tests for configuration defaults and presets |

## Acceptance Criteria

- [ ] Requests are retried up to `maxRetries` times on retryable
      errors
- [ ] Exponential backoff with jitter is applied between retries
- [ ] `Retry-After` header is respected when present
- [ ] Non-retryable errors are thrown immediately without retry
- [ ] Cancellation stops the retry loop
- [ ] Default configuration (no retry) preserves current behaviour
      with no breaking changes
- [ ] `RetryHTTPClient` is a decorator that wraps any `HTTPClient`
- [ ] Unit tests verify retry count, delay calculation, and error
      propagation
- [ ] `make ci` passes

## Dependencies

- None. This PRD is independent and can be implemented in any order.
- **PRD-003 benefits from this** — auto-pagination over many pages is
  more robust when 429 responses are retried automatically.
- **PRD-005 interacts with this** — both modify `TMDbConfiguration`.
  If both are implemented, ensure properties are added together.

## Out of Scope

- Circuit breaker pattern
- Per-endpoint retry configuration
- Retry for network connectivity errors (e.g., no internet)
- Retry budget or rate limiting on the client side
- Persistent retry queue for offline scenarios
