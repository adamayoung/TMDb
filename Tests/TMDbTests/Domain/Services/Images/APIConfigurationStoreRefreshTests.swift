//
//  APIConfigurationStoreRefreshTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .images))
struct APIConfigurationStoreRefreshTests {

    @Test("refresh re-fetches and re-memoises the new value")
    func refreshReFetchesAndReMemoisesNewValue() async throws {
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

    @Test("concurrent refresh calls share a single fetch")
    func concurrentRefreshCallsShareSingleFetch() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let expectedResult = APIConfiguration.mock(changeKeys: ["first"])
        configurationService.enqueue(.success(expectedResult))
        configurationService.enqueue(.success(.mock(changeKeys: ["second"])))
        let store = APIConfigurationStore(configurationService: configurationService)

        let firstRefresh = Task { try await store.refresh() }
        await gate.waitUntilEntered(atLeast: 1)

        // Arrives while the first refresh is still fetching: it should join that
        // fetch rather than supersede it, which would waste the first's round trip
        // and discard its result.
        //
        // A joining refresh never reaches the gate, so wait on the store's own
        // entry count instead. Without this barrier the fetch could commit first,
        // leaving the second refresh to start its own — an intermittent red on
        // exactly the guarantee this test exists to protect.
        let secondRefresh = Task { try await store.refresh() }
        await store.waitUntilCallersEntered(atLeast: 2)

        await gate.open()

        let firstResult = try await firstRefresh.value
        let secondResult = try await secondRefresh.value

        #expect(firstResult == expectedResult)
        #expect(secondResult == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)

        // …and that shared fetch must still have been memoised.
        let cached = try await store.apiConfiguration()

        #expect(cached == expectedResult)
        #expect(configurationService.apiConfigurationCallCount == 1)
    }

    @Test("apiConfiguration during an in-flight refresh serves the cached value")
    func apiConfigurationDuringInFlightRefreshServesCachedValue() async throws {
        let gate = FetchGate()
        let configurationService = CountingConfigurationService(gate: gate)
        let firstResult = APIConfiguration.mock(changeKeys: ["first"])
        configurationService.enqueue(.success(firstResult))
        configurationService.enqueue(.success(.mock(changeKeys: ["second"])))
        let store = APIConfigurationStore(configurationService: configurationService)

        // Prime the cache through an open gate, then close it so the refresh parks.
        await gate.open()
        let cached = try await store.apiConfiguration()
        #expect(cached == firstResult)
        #expect(configurationService.apiConfigurationCallCount == 1)
        await gate.close()

        let refreshing = Task { try await store.refresh() }
        await store.waitUntilCallersEntered(atLeast: 2)

        // Readers must not block on the in-flight refresh — they keep the cached
        // value until a replacement actually lands. Moving apiConfiguration()'s
        // cache check after the fetch join would make every reader wait here.
        let during = try await store.apiConfiguration()

        #expect(during == firstResult)
        #expect(configurationService.apiConfigurationCallCount == 2)

        await gate.open()
        _ = try await refreshing.value
    }

    @Test("a failed refresh keeps the previously cached configuration")
    func failedRefreshKeepsPreviouslyCachedConfiguration() async throws {
        let configurationService = CountingConfigurationService()
        let expectedResult = APIConfiguration.mock(changeKeys: ["first"])
        configurationService.enqueue(.success(expectedResult))
        configurationService.enqueue(.failure(.unknown))
        let store = APIConfigurationStore(configurationService: configurationService)

        let before = try await store.apiConfiguration()
        #expect(configurationService.apiConfigurationCallCount == 1)

        await #expect(throws: TMDbError.unknown) {
            _ = try await store.refresh()
        }

        // A refresh that fails must not destroy a known-good configuration: losing
        // it would make every later image URL re-fetch until the network recovers.
        let after = try await store.apiConfiguration()

        #expect(before == expectedResult)
        #expect(after == expectedResult)
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

}
