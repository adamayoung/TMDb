//
//  APIConfigurationStore.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
actor APIConfigurationStore {

    private typealias Fetch = Task<Result<APIConfiguration, TMDbError>, Never>

    private let configurationService: any ConfigurationService
    private var cachedConfiguration: APIConfiguration?
    private var inFlightFetch: Fetch?
    private var generation: UInt64 = 0
    private var refreshGeneration: UInt64?

    /// The number of calls that have entered ``apiConfiguration()`` or ``refresh()``.
    ///
    /// Incremented on the actor before the first suspension point, so a test can
    /// wait until callers have provably joined an in-flight fetch rather than
    /// assuming task-start ordering. It has no effect on behaviour.
    private(set) var entryCount = 0

    init(configurationService: some ConfigurationService) {
        self.configurationService = configurationService
    }

    func apiConfiguration() async throws(TMDbError) -> APIConfiguration {
        entryCount += 1

        // Checked before joining any in-flight fetch, so a refresh in progress
        // does not make readers wait: they keep getting the cached value until
        // the replacement lands.
        if let cachedConfiguration {
            return cachedConfiguration
        }

        return try await result(of: currentFetch())
    }

    func refresh() async throws(TMDbError) -> APIConfiguration {
        entryCount += 1

        // Coalesce concurrent refreshes. A refresh arriving while an earlier
        // refresh's fetch is still running joins it rather than superseding it,
        // which would waste that round trip against a rate-limited API and
        // discard its result without ever caching it.
        //
        // Joining is sound because the in-flight fetch was issued after the
        // cached value it will replace, so it is strictly fresher than anything
        // this caller could already have observed. Note it may have been issued
        // slightly *before* this call, so a change made in that window is not
        // guaranteed to be reflected.
        if let inFlightFetch, refreshGeneration == generation {
            return try await result(of: inFlightFetch)
        }

        invalidate()
        refreshGeneration = generation

        return try await result(of: currentFetch())
    }

    /// Starts a new generation, detaching any in-flight fetch.
    ///
    /// The in-flight fetch is deliberately **not** cancelled: it may have many
    /// awaiters, and cancelling it would fail all of them because someone else
    /// refreshed. It is left to run and deliver its value to the callers that
    /// asked before the refresh; the generation bump stops it committing.
    ///
    /// The cached value is deliberately **kept**. Clearing it here would mean a
    /// refresh that then fails leaves the store with no configuration at all, so
    /// a transient network loss during a refresh would degrade every later image
    /// URL until connectivity returned. ``complete(_:generation:)`` swaps the
    /// cached value only once a replacement has actually arrived.
    private func invalidate() {
        generation &+= 1
        inFlightFetch = nil
    }

    private func result(of fetch: Fetch) async throws(TMDbError) -> APIConfiguration {
        try await fetch.value.get()
    }

    private func currentFetch() -> Fetch {
        if let inFlightFetch {
            return inFlightFetch
        }

        let configurationService = configurationService
        let generation = generation

        // `do throws(TMDbError)` is mandatory: typed-throws inference does not
        // apply inside a closure, so a bare `catch` would bind `any Error`.
        // `complete` is called WITHOUT `await` — this Task inherits the actor's
        // isolation, and a redundant `await` is fatal under -warnings-as-errors.
        let fetch = Fetch {
            let result: Result<APIConfiguration, TMDbError>
            do throws(TMDbError) {
                result = try await .success(configurationService.apiConfiguration())
            } catch {
                result = .failure(error)
            }

            self.complete(result, generation: generation)

            return result
        }

        // Published before the first suspension point, so a concurrent caller can
        // never observe "no cache and no fetch" while this fetch is running.
        inFlightFetch = fetch

        return fetch
    }

    /// Commits a completed fetch, unless it has been superseded by a ``refresh()``.
    ///
    /// Called from inside the fetch task itself rather than from an awaiter's
    /// continuation. Once the task resumes it is back on the actor, and runs this
    /// commit and its return with no suspension in between — so nothing can
    /// interleave between the commit and the task completing. That yields the
    /// invariant `inFlightFetch != nil` **iff** its task has not yet committed,
    /// which is what stops a late caller joining an already-finished fetch.
    private func complete(
        _ result: Result<APIConfiguration, TMDbError>,
        generation: UInt64
    ) {
        // Superseded by a refresh: touch nothing. Clearing `inFlightFetch` here
        // would detach the refresh's live fetch (causing a redundant third fetch),
        // and caching this value would clobber the newer one.
        guard generation == self.generation else {
            return
        }

        inFlightFetch = nil
        refreshGeneration = nil

        // Only successes are memoised, so a failure retries on the next call.
        if case .success(let configuration) = result {
            cachedConfiguration = configuration
        }
    }

}
