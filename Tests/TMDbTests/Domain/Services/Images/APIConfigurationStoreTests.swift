//
//  APIConfigurationStoreTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .images))
struct APIConfigurationStoreTests {

    @Test("apiConfiguration fetches and returns the configuration")
    func apiConfigurationFetchesAndReturnsConfiguration() async throws {
        let configurationService = CountingConfigurationService()
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        let result = try await store.apiConfiguration()

        #expect(result == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("apiConfiguration when called twice fetches only once")
    func apiConfigurationWhenCalledTwiceFetchesOnlyOnce() async throws {
        let configurationService = CountingConfigurationService()
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        let first = try await store.apiConfiguration()
        let second = try await store.apiConfiguration()

        #expect(first == expectedResult)
        #expect(second == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("apiConfiguration under 100 concurrent callers fetches exactly once")
    func apiConfigurationUnderConcurrentCallersFetchesExactlyOnce() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        let results = await withTaskGroup(
            of: Result<APIConfiguration, TMDbError>.self
        ) { group in
            for _ in 0 ..< 100 {
                group.addTask {
                    // Typed-throws inference does not apply inside a closure, so a
                    // bare `catch` would bind `any Error`.
                    do throws(TMDbError) {
                        return try await .success(store.apiConfiguration())
                    } catch {
                        return .failure(error)
                    }
                }
            }

            // Hold the window open until a fetch has provably reached the gate,
            // then release. Without this the test could pass by scheduling luck.
            await gate.waitUntilEntered(atLeast: 1)
            await gate.open()

            var results: [Result<APIConfiguration, TMDbError>] = []
            for await result in group {
                results.append(result)
            }

            return results
        }

        #expect(configurationService.apiConfigurationCallCount == 1)
        #expect(configurationService.peakConcurrency == 1)
        #expect(results.count == 100)
        for result in results {
            #expect(try result.get() == expectedResult)
        }
    }

    @Test("apiConfiguration when the fetch fails throws the error")
    func apiConfigurationWhenFetchFailsThrowsError() async throws {
        let configurationService = CountingConfigurationService()
        configurationService.enqueue(.failure(.unknown))
        let store = APIConfigurationStore(configurationService: configurationService)

        await #expect(throws: TMDbError.unknown) {
            _ = try await store.apiConfiguration()
        }

        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("apiConfiguration when the first fetch fails retries on the next call")
    func apiConfigurationWhenFirstFetchFailsRetriesOnNextCall() async throws {
        let configurationService = CountingConfigurationService()
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.failure(.unknown))
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        await #expect(throws: TMDbError.unknown) {
            _ = try await store.apiConfiguration()
        }

        let result = try await store.apiConfiguration()

        #expect(result == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 2)
    }

    @Test("apiConfiguration when a concurrent fetch fails shares the failure, then retries")
    func apiConfigurationWhenConcurrentFetchFailsSharesFailureThenRetries() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        configurationService.enqueue(.failure(.unknown))
        let store = APIConfigurationStore(configurationService: configurationService)

        let failureCount = await withTaskGroup(of: Bool.self) { group in
            for _ in 0 ..< 10 {
                group.addTask {
                    do {
                        _ = try await store.apiConfiguration()
                        return false
                    } catch {
                        return true
                    }
                }
            }

            await gate.waitUntilEntered(atLeast: 1)
            await gate.open()

            return await group.reduce(into: 0) { count, didFail in
                count += didFail ? 1 : 0
            }
        }

        // One fetch, ten shared failures — and nothing memoised.
        #expect(failureCount == 10)
        #expect(configurationService.apiConfigurationCallCount == 1)

        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))

        let result = try await store.apiConfiguration()

        #expect(result == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 2)
    }

    @Test("refresh discards the memo, re-fetches, and re-memoises the new value")
    func refreshDiscardsMemoAndReMemoisesNewValue() async throws {
        let configurationService = CountingConfigurationService()
        let firstResult = APIConfiguration.mock(changeKeys: ["first"])
        let secondResult = APIConfiguration.mock(changeKeys: ["second"])
        configurationService.enqueue(.success(firstResult))
        configurationService.enqueue(.success(secondResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        let first = try await store.apiConfiguration()
        let cached = try await store.apiConfiguration()
        #expect(configurationService.apiConfigurationCallCount == 1)

        let refreshed = try await store.refresh()
        let afterRefresh = try await store.apiConfiguration()

        #expect(first == firstResult)
        #expect(cached == firstResult)
        #expect(refreshed == secondResult)
        #expect(afterRefresh == secondResult)
        #expect(configurationService.apiConfigurationCallCount == 2)
    }

    @Test("refresh while a first fetch is in flight does not let the superseded fetch win")
    func refreshWhileFirstFetchInFlightDoesNotLetSupersededFetchWin() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let firstResult = APIConfiguration.mock(changeKeys: ["first"])
        let secondResult = APIConfiguration.mock(changeKeys: ["second"])
        configurationService.enqueue(.success(firstResult))
        configurationService.enqueue(.success(secondResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        // Park a first fetch at the gate.
        async let parked = store.apiConfiguration()
        await gate.waitUntilEntered(atLeast: 1)

        // Supersede it. Its own fetch also parks at the gate.
        async let refreshed = store.refresh()
        await gate.waitUntilEntered(atLeast: 2)

        await gate.open()

        let parkedResult = try await parked
        let refreshedResult = try await refreshed

        // The parked caller asked before the refresh, so it correctly receives the
        // pre-refresh value; the refresh caller receives the fresh one.
        #expect(parkedResult == firstResult)
        #expect(refreshedResult == secondResult)
        #expect(configurationService.apiConfigurationCallCount == 2)

        // The superseded fetch must not have clobbered the cache, nor detached the
        // refresh's fetch (which would cause a third fetch here).
        let afterRefresh = try await store.apiConfiguration()

        #expect(afterRefresh == secondResult)
        #expect(configurationService.apiConfigurationCallCount == 2)
    }

    @Test("a superseded fetch that fails does not detach the refresh's fetch")
    func supersededFetchThatFailsDoesNotDetachRefreshFetch() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let expectedResult = APIConfiguration.mock(changeKeys: ["second"])
        configurationService.enqueue(.failure(.unknown))
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        // Explicit `Task` handles rather than `async let`: an `async let` binding
        // cannot be captured by the `#expect(throws:)` closure.
        let parkedCaller = Task { try await store.apiConfiguration() }
        await gate.waitUntilEntered(atLeast: 1)

        let refreshCaller = Task { try await store.refresh() }
        await gate.waitUntilEntered(atLeast: 2)

        await gate.open()

        await #expect(throws: TMDbError.unknown) {
            _ = try await parkedCaller.value
        }
        let refreshedResult = try await refreshCaller.value

        #expect(refreshedResult == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 2)

        // The superseded failure must not have cleared the refresh's committed
        // cache entry — a third fetch here would mean it did.
        let afterRefresh = try await store.apiConfiguration()

        #expect(afterRefresh == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 2)
    }

    @Test("cancelling one caller does not starve the others sharing the fetch")
    func cancellingOneCallerDoesNotStarveTheOthers() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        let cancelledCaller = Task { try await store.apiConfiguration() }
        await gate.waitUntilEntered(atLeast: 1)

        async let second: APIConfiguration = store.apiConfiguration()
        async let third: APIConfiguration = store.apiConfiguration()

        cancelledCaller.cancel()
        await gate.open()

        let secondResult = try await second
        let thirdResult = try await third

        // The shared fetch is deliberately not cancellable by any one awaiter:
        // forwarding cancellation into it (as PagedAsyncSequence does, correctly,
        // for its single owner) would fail every other caller here.
        #expect(secondResult == expectedResult)
        #expect(thirdResult == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)

        // Documented consequence: the cancelled caller is unresponsive to
        // cancellation — it completes with the value rather than throwing.
        let cancelledResult = try await cancelledCaller.value

        #expect(cancelledResult == expectedResult)
    }

}
