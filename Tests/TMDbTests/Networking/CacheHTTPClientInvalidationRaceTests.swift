//
//  CacheHTTPClientInvalidationRaceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Interleavings where a read is still in flight when a mutation invalidates
/// the cache.
///
/// Bounded because a regression here presents as a hang rather than a failure:
/// these park a request on `FetchGate`, whose continuation cancellation does not
/// resume.
///
@Suite(.tags(.networking), .timeLimit(.minutes(1)))
struct CacheHTTPClientInvalidationRaceTests {

    private static let defaultConfig = CacheConfiguration(
        defaultTTL: .seconds(60),
        maximumEntryCount: 100
    )

    @Test("in-flight GET does not repopulate the cache a successful mutation invalidated")
    func inFlightGetDoesNotRepopulateInvalidatedCache() async throws {
        let gate = FetchGate()
        let mockClient = SequencingHTTPMockClient()
        // Slot 0: held in flight across the mutation, so it carries pre-mutation state.
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("stale".utf8))),
            gate: gate
        )
        // Slot 1: the mutation that invalidates the cache.
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200)))
        // Slot 2: the re-fetch that the invalidation must force.
        mockClient.enqueue(.success(HTTPResponse(statusCode: 200, data: Data("fresh".utf8))))
        // Slot 3 is never reached while caching still works. It exists so that a
        // guard so eager it disables the cache outright fails as a body mismatch
        // rather than tripping the mock's `preconditionFailure`, which would abort
        // the whole test process instead of failing this one test.
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("should-not-be-refetched".utf8)))
        )

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let getURL = try #require(URL(string: "https://api.example.com/movie/550"))
        let postURL = try #require(URL(string: "https://api.example.com/movie/550/rating"))

        // Unstructured rather than `async let`: `FetchGate.wait()` parks on a bare
        // continuation that cancellation does not resume, and `async let` cancels
        // *and then awaits* its child at scope exit — so an early throw would hang
        // the suite instead of failing it.
        let parkedGet = Task {
            try await cacheClient.perform(request: HTTPRequest(url: getURL))
        }

        // Load-bearing, twice over: results are handed out in arrival order, so the
        // GET must take slot 0 before the mutation is issued; and reaching the
        // transport proves the GET is past the generation it captured.
        await gate.waitUntilEntered(atLeast: 1)

        // Captured instead of `try`-ed so that `gate.open()` is reached on every
        // path — an unopened gate leaves `parkedGet` suspended forever.
        let mutation: Result<HTTPResponse, any Error>
        do {
            mutation = try await .success(
                cacheClient.perform(
                    request: HTTPRequest(url: postURL, method: .post, body: Data())
                )
            )
        } catch {
            mutation = .failure(error)
        }

        await gate.open()
        let inFlightResponse = try await parkedGet.value
        let mutationResponse = try mutation.get()

        #expect(mutationResponse.statusCode == 200)
        #expect(inFlightResponse.data == Data("stale".utf8))

        // The pre-mutation response must not have been written into the cache the
        // mutation just invalidated.
        let refetched = try await cacheClient.perform(request: HTTPRequest(url: getURL))
        #expect(refetched.data == Data("fresh".utf8))
        #expect(mockClient.performCount == 3)

        // ...and caching must still work afterwards. Without this, an over-broad
        // guard that permanently stops writing passes every assertion above.
        let cached = try await cacheClient.perform(request: HTTPRequest(url: getURL))
        #expect(cached.data == Data("fresh".utf8))
        #expect(mockClient.performCount == 3)
    }

    ///
    /// A guard, not a reproducer: this passes both before and after the
    /// generation guard exists, because an unguarded write and a write whose
    /// generation still matches behave identically. It exists to catch the
    /// opposite defect — a guard so eager that it also drops writes no mutation
    /// invalidated.
    ///
    @Test("in-flight GET is still cached when the mutation it raced against failed")
    func inFlightGetIsCachedWhenMutationFailed() async throws {
        let gate = FetchGate()
        let mockClient = SequencingHTTPMockClient()
        // Slot 0: held in flight across the failed mutation.
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("first".utf8))),
            gate: gate
        )
        // Slot 1: the mutation fails, so it must not invalidate anything.
        mockClient.enqueue(.success(HTTPResponse(statusCode: 500)))
        // Slot 2 is never reached while the write is kept. It exists so that an
        // over-eager guard fails as a body mismatch rather than tripping the
        // mock's `preconditionFailure`, which would abort the whole test process.
        mockClient.enqueue(
            .success(HTTPResponse(statusCode: 200, data: Data("should-not-be-fetched".utf8)))
        )

        let cacheClient = CacheHTTPClient(
            httpClient: mockClient,
            configuration: Self.defaultConfig
        )
        let getURL = try #require(URL(string: "https://api.example.com/movie/550"))
        let postURL = try #require(URL(string: "https://api.example.com/movie/550/rating"))

        let parkedGet = Task {
            try await cacheClient.perform(request: HTTPRequest(url: getURL))
        }

        await gate.waitUntilEntered(atLeast: 1)

        let mutation: Result<HTTPResponse, any Error>
        do {
            mutation = try await .success(
                cacheClient.perform(
                    request: HTTPRequest(url: postURL, method: .post, body: Data())
                )
            )
        } catch {
            mutation = .failure(error)
        }

        await gate.open()
        _ = try await parkedGet.value
        let mutationResponse = try mutation.get()

        #expect(mutationResponse.statusCode == 500)

        // Nothing was invalidated, so the in-flight write stands and this is a hit.
        let cached = try await cacheClient.perform(request: HTTPRequest(url: getURL))
        #expect(cached.data == Data("first".utf8))
        #expect(mockClient.performCount == 2)
    }

}
