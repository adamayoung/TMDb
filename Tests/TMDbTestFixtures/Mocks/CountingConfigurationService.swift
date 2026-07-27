//
//  CountingConfigurationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb

///
/// Holds a fetch open until the test explicitly releases it.
///
/// Interleaving tests must not depend on a `Task.sleep` being "long enough" —
/// that is flaky on loaded CI. A gate holds the race window open until `open()`
/// is called, making the interleaving deterministic.
///
package actor FetchGate {

    private var isOpen = false
    private var waiters: [CheckedContinuation<Void, Never>] = []
    private var entered = 0

    package init() {}

    /// The number of fetches that have reached the gate.
    package var enteredCount: Int {
        entered
    }

    /// Suspends the caller until ``open()`` is called. Returns immediately once open.
    package func wait() async {
        entered += 1
        if isOpen {
            return
        }

        await withCheckedContinuation { continuation in
            waiters.append(continuation)
        }
    }

    /// Releases every parked caller, and lets subsequent callers straight through.
    package func open() {
        isOpen = true
        let pending = waiters
        waiters.removeAll()
        for continuation in pending {
            continuation.resume()
        }
    }

    /// Parks callers arriving from now on. Already-released callers are unaffected.
    ///
    /// Lets a test prime a cache through an open gate and then hold a later fetch
    /// open, without needing a second store.
    package func close() {
        isOpen = false
    }

    ///
    /// Suspends until at least `count` fetches have reached the gate, or the
    /// deadline passes.
    ///
    /// The deadline matters: the regressions these tests exist to catch are ones
    /// where an expected fetch never starts. An unbounded wait would turn such a
    /// regression into a CI job timeout with no diagnostic, which is far worse
    /// than a failed assertion. On expiry this records an issue and returns, so
    /// the caller's own expectations fail with a real message.
    ///
    package func waitUntilEntered(
        atLeast count: Int,
        within timeout: Duration = .seconds(10),
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        let deadline = ContinuousClock.now + timeout

        while entered < count {
            guard ContinuousClock.now < deadline else {
                Issue.record(
                    """
                    Only \(entered) of \(count) fetches reached the gate within \
                    \(timeout). The fetch that was expected to start never did.
                    """,
                    sourceLocation: sourceLocation
                )

                return
            }

            await Task.yield()
        }
    }

}

///
/// A `ConfigurationService` double that counts `apiConfiguration()` calls and
/// records how many were ever in flight at once.
///
/// State is `NSLock`-guarded so this is safe to drive from many concurrent
/// callers — unlike `MockAPIClient`, whose mutable state is unsynchronised.
///
/// - Note: Only `apiConfiguration()` is implemented; the remaining requirements
///   trap, so an unexpected call is loud rather than silent.
///
package final class CountingConfigurationService: ConfigurationService, @unchecked Sendable {

    private let lock = NSLock()
    private var results: [Result<APIConfiguration, TMDbError>] = []
    private var count = 0
    private var activeFetches = 0
    private var peak = 0
    private let gate: FetchGate?

    /// Creates a counting double, optionally parked behind `gate`.
    package init(gate: FetchGate? = nil) {
        self.gate = gate
    }

    /// The number of times `apiConfiguration()` has been called.
    package var apiConfigurationCallCount: Int {
        lock.withLock { count }
    }

    /// The greatest number of fetches ever in flight at once. Greater than 1 proves
    /// de-duplication failed.
    package var peakConcurrency: Int {
        lock.withLock { peak }
    }

    /// Appends a result to the queue. The last enqueued result serves any further calls.
    package func enqueue(_ result: Result<APIConfiguration, TMDbError>) {
        lock.withLock { results.append(result) }
    }

    package func apiConfiguration() async throws(TMDbError) -> APIConfiguration {
        let index: Int = lock.withLock {
            let index = count
            count += 1
            activeFetches += 1
            peak = max(peak, activeFetches)
            return index
        }

        // Decremented only after the gate releases, so `peak` counts fetches that
        // are concurrently suspended — which is the whole point of the measurement.
        defer { lock.withLock { activeFetches -= 1 } }

        await gate?.wait()

        let result: Result<APIConfiguration, TMDbError> = lock.withLock {
            guard results.indices.contains(index) else {
                return results.last ?? .failure(.unknown)
            }

            return results[index]
        }

        return try result.get()
    }

    package func countries(language _: String?) async throws(TMDbError) -> [Country] {
        preconditionFailure("Unused by CountingConfigurationService")
    }

    package func jobsByDepartment() async throws(TMDbError) -> [Department] {
        preconditionFailure("Unused by CountingConfigurationService")
    }

    package func languages() async throws(TMDbError) -> [Language] {
        preconditionFailure("Unused by CountingConfigurationService")
    }

    package func primaryTranslations() async throws(TMDbError) -> [String] {
        preconditionFailure("Unused by CountingConfigurationService")
    }

    package func timezones() async throws(TMDbError) -> [Timezone] {
        preconditionFailure("Unused by CountingConfigurationService")
    }

}
