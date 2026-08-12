//
//  APIConfigurationStoreTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

/// A regression in the cancellable join presents as a hang, not a failure, and
/// neither this suite nor the CI jobs bound one today. The time limit converts a
/// *slow* join into a failure — but it cannot rescue a continuation that is never
/// resumed at all: that task is not cancellable, so the timeout blocks with it
/// (see `knowledge/gotchas.md`). The real backstop is `ResumeOnceTests`, which
/// exercises the primitive directly.
@Suite(.tags(.services, .images), .timeLimit(.minutes(1)))
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

            // Hold the window open until every caller has provably joined the
            // in-flight fetch, then release. Without this the test could pass by
            // scheduling luck.
            await store.waitUntilCallersEntered(atLeast: 100)
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

            // All ten must have joined the in-flight fetch before it is released.
            // A failure is deliberately not memoised, so a straggler arriving
            // after it completes would find no cache and no in-flight fetch and
            // start a second one.
            await store.waitUntilCallersEntered(atLeast: 10)
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

    @Test("cancelling one caller does not starve the others sharing the fetch")
    func cancellingOneCallerDoesNotStarveTheOthers() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        let cancelledCaller = Task { try await store.apiConfiguration() }
        await gate.waitUntilEntered(atLeast: 1)

        // Both must have joined the same in-flight fetch before the gate opens,
        // otherwise they would read the committed cache instead and the test
        // would not exercise sharing at all.
        let second = Task { try await store.apiConfiguration() }
        let third = Task { try await store.apiConfiguration() }
        await store.waitUntilCallersEntered(atLeast: 3)

        cancelledCaller.cancel()
        await gate.open()

        let secondResult = try await second.value
        let thirdResult = try await third.value

        // The shared fetch is still never cancelled by any one awaiter:
        // forwarding cancellation into it would fail every other caller here.
        #expect(secondResult == expectedResult)
        #expect(thirdResult == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)

        // The cancelled caller abandons its wait instead of being dragged along
        // to the end of a fetch it no longer wants.
        await #expect(throws: TMDbError.cancelled) {
            _ = try await cancelledCaller.value
        }
    }

    @Test("cancelling an awaiter leaves the shared fetch to commit for later callers")
    func cancellingAnAwaiterLeavesSharedFetchToCommit() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        let cancelledCaller = Task { try await store.apiConfiguration() }
        await store.waitUntilCallersEntered(atLeast: 1)

        cancelledCaller.cancel()
        await gate.open()

        await #expect(throws: TMDbError.cancelled) {
            _ = try await cancelledCaller.value
        }

        // The abandoned fetch still ran to completion and memoised its value, so
        // a later caller is served from cache rather than paying a second trip.
        let later = try await store.apiConfiguration()

        #expect(later == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("a caller cancelled before entry throws without starting a fetch")
    func callerCancelledBeforeEntryThrowsWithoutFetching() async {
        let configurationService = CountingConfigurationService()
        configurationService.enqueue(.success(APIConfiguration.mock()))
        let store = APIConfigurationStore(configurationService: configurationService)

        let task = Task { () -> TMDbError? in
            while !Task.isCancelled {
                await Task.yield()
            }

            do throws(TMDbError) {
                _ = try await store.apiConfiguration()
                return nil
            } catch {
                return error
            }
        }

        task.cancel()

        #expect(await task.value == .cancelled)
        #expect(configurationService.apiConfigurationCallCount == 0)
    }

    @Test("a cancelled refresh does not perturb the generation")
    func cancelledRefreshDoesNotPerturbGeneration() async throws {
        let configurationService = CountingConfigurationService()
        let expectedResult = APIConfiguration.mock()
        configurationService.enqueue(.success(expectedResult))
        let store = APIConfigurationStore(configurationService: configurationService)

        // Prime the cache so a stray generation bump would be observable as a
        // lost cached value on the next read.
        _ = try await store.apiConfiguration()

        let task = Task { () -> TMDbError? in
            while !Task.isCancelled {
                await Task.yield()
            }

            do throws(TMDbError) {
                _ = try await store.refresh()
                return nil
            } catch {
                return error
            }
        }

        task.cancel()

        #expect(await task.value == .cancelled)

        let afterCancelledRefresh = try await store.apiConfiguration()

        #expect(afterCancelledRefresh == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("a cancelled awaiter of a superseded fetch resolves rather than hanging")
    func cancelledAwaiterOfSupersededFetchResolves() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let first = APIConfiguration.mock()
        let second = APIConfiguration.mock()
        configurationService.enqueue(.success(first))
        configurationService.enqueue(.success(second))
        let store = APIConfigurationStore(configurationService: configurationService)

        // Park a caller on fetch #1, then supersede it with a refresh so its
        // commit is discarded by the generation guard.
        let cancelledCaller = Task { try await store.apiConfiguration() }
        await store.waitUntilCallersEntered(atLeast: 1)

        let refresher = Task { try await store.refresh() }
        await store.waitUntilCallersEntered(atLeast: 2)

        cancelledCaller.cancel()
        await gate.open()

        // The superseded fetch's awaiter must still resolve — a waiter whose
        // fetch never commits is exactly the leak that would hang here.
        await #expect(throws: TMDbError.cancelled) {
            _ = try await cancelledCaller.value
        }

        _ = try await refresher.value
    }

}
