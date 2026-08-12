//
//  TMDbAPIClientCancellationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

@Suite(.tags(.networking))
struct TMDbAPIClientCancellationTests {

    private func makeAPIClient(httpClient: some HTTPClient) throws -> TMDbAPIClient {
        try TMDbAPIClient(
            credential: .apiKey("abc123"),
            baseURL: #require(URL(string: "https://some.domain.com/path")),
            serialiser: TMDbJSONSerialiser(),
            httpClient: httpClient
        )
    }

    /// Performs a request on a task that is cancelled before the transport runs,
    /// so the classification is exercised with `Task.isCancelled == true` without
    /// depending on any timing.
    private func performOnCancelledTask(
        throwing error: Error
    ) async throws -> TMDbAPIError? {
        let httpClient = SequencingHTTPMockClient()
        httpClient.enqueue(.failure(error))
        let apiClient = try makeAPIClient(httpClient: httpClient)

        let task = Task { () -> TMDbAPIError? in
            while !Task.isCancelled {
                await Task.yield()
            }

            do {
                _ = try await apiClient.perform(APIStubRequest<String, String>(path: "/endpoint"))
                return nil
            } catch let caught {
                return caught as? TMDbAPIError
            }
        }

        task.cancel()

        return await task.value
    }

    @Test("perform when the transport throws CancellationError throws cancelled")
    func performWhenTransportThrowsCancellationErrorThrowsCancelled() async throws {
        let httpClient = SequencingHTTPMockClient()
        httpClient.enqueue(.failure(CancellationError()))
        let apiClient = try makeAPIClient(httpClient: httpClient)

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(APIStubRequest<String, String>(path: "/endpoint"))
        } catch let caught {
            error = caught as? TMDbAPIError
        }

        #expect(error == .cancelled)
    }

    @Test("perform on a cancelled task when the transport throws URLError cancelled throws cancelled")
    func performOnCancelledTaskWithURLErrorCancelledThrowsCancelled() async throws {
        let error = try await performOnCancelledTask(throwing: URLError(.cancelled))

        #expect(error == .cancelled)
    }

    @Test("perform on a cancelled task when the transport throws an NSURLErrorCancelled NSError throws cancelled")
    func performOnCancelledTaskWithNSURLErrorCancelledThrowsCancelled() async throws {
        // The Linux transport delivers an `NSError` in `NSURLErrorDomain` rather
        // than a Swift `URLError`. This is the only check that covers that
        // bridge — the integration suite never runs on Linux in CI.
        let nsError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled)

        let error = try await performOnCancelledTask(throwing: nsError)

        #expect(error == .cancelled)
    }

    @Test("perform on a LIVE task when the transport throws URLError cancelled throws network")
    func performOnLiveTaskWithURLErrorCancelledThrowsNetwork() async throws {
        // `URLSession.invalidateAndCancel()` and app teardown raise `.cancelled`
        // while the caller's task is alive. That is a real failure and must not
        // be swallowed by a consumer's `catch TMDbError.cancelled`.
        let httpClient = SequencingHTTPMockClient()
        httpClient.enqueue(.failure(URLError(.cancelled)))
        let apiClient = try makeAPIClient(httpClient: httpClient)

        var error: TMDbAPIError?
        do {
            _ = try await apiClient.perform(APIStubRequest<String, String>(path: "/endpoint"))
        } catch let caught {
            error = caught as? TMDbAPIError
        }

        #expect(error == .network(URLError(.cancelled)))
    }

    @Test("perform on a cancelled task when the transport times out still throws network")
    func performOnCancelledTaskWithTimeoutStillThrowsNetwork() async throws {
        let error = try await performOnCancelledTask(throwing: URLError(.timedOut))

        #expect(error == .network(URLError(.timedOut)))
    }

    @Test("a cancelled request surfaces as TMDbError cancelled through the mapping client")
    func cancelledRequestSurfacesAsTMDbErrorCancelledThroughMappingClient() async throws {
        let httpClient = SequencingHTTPMockClient()
        httpClient.enqueue(.failure(CancellationError()))
        let apiClient = try ErrorMappingAPIClient(apiClient: makeAPIClient(httpClient: httpClient))

        var error: TMDbError?
        do {
            _ = try await apiClient.perform(APIStubRequest<String, String>(path: "/endpoint"))
        } catch let caught {
            error = caught
        }

        #expect(error == .cancelled)
    }

    @Test("cancelling during retry backoff surfaces as cancelled, not network")
    func cancellingDuringRetryBackoffSurfacesAsCancelled() async throws {
        // The second wire shape, composed rather than injected: a real
        // `RetryHTTPClient` parked in `Task.sleep` raises a bare
        // `CancellationError`, which only becomes `.cancelled` once it passes
        // through `TMDbAPIClient`. Testing the two layers separately leaves the
        // seam between them unproven.
        let httpClient = SequencingHTTPMockClient()
        for _ in 0 ... 3 {
            // `Retry-After` makes the backoff exactly `min(60s, maxDelay)`.
            // Without it the delay is `Double.random(in: 0 ... 60)`, which wakes
            // before the 50ms cancel roughly once in 1200 runs and retries.
            httpClient.enqueue(
                .success(HTTPResponse(statusCode: 429, headers: ["Retry-After": "60"]))
            )
        }

        let retryClient = RetryHTTPClient(
            httpClient: httpClient,
            configuration: RetryConfiguration(
                maxRetries: 3,
                initialDelay: .seconds(60),
                maxDelay: .seconds(60),
                retryableErrors: [.rateLimit]
            )
        )
        let apiClient = try ErrorMappingAPIClient(
            apiClient: makeAPIClient(httpClient: retryClient)
        )

        let task = Task { () -> TMDbError? in
            do throws(TMDbError) {
                _ = try await apiClient.perform(APIStubRequest<String, String>(path: "/endpoint"))
                return nil
            } catch {
                return error
            }
        }

        // Let the first attempt fail and the client park in its 60s backoff. The
        // sleep is a regression ceiling, not a happy-path wait.
        try await Task.sleep(for: .milliseconds(50))
        task.cancel()

        #expect(await task.value == .cancelled)

        // The first attempt ran; the retries never did.
        #expect(httpClient.performCount == 1)
    }

    @Test("sibling cancellation in a task group reports cancelled, never network")
    func siblingCancellationInATaskGroupReportsCancelledNeverNetwork() async throws {
        // The reported failure from issue #419: cancelling a task group made every
        // sibling surface a phantom `.network` error.
        let httpClient = SequencingHTTPMockClient()
        for _ in 0 ..< 8 {
            httpClient.enqueue(.failure(URLError(.cancelled)))
        }
        let apiClient = try ErrorMappingAPIClient(apiClient: makeAPIClient(httpClient: httpClient))

        let errors = await withTaskGroup(of: TMDbError?.self) { group in
            for _ in 0 ..< 8 {
                group.addTask {
                    while !Task.isCancelled {
                        await Task.yield()
                    }

                    do throws(TMDbError) {
                        _ = try await apiClient.perform(
                            APIStubRequest<String, String>(path: "/endpoint")
                        )
                        return nil
                    } catch {
                        return error
                    }
                }
            }

            group.cancelAll()

            var errors: [TMDbError?] = []
            for await error in group {
                errors.append(error)
            }

            return errors
        }

        #expect(errors.count == 8)
        for error in errors {
            #expect(error == .cancelled)
        }
    }

}
