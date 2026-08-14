//
//  FetchGate.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

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
    /// - Important: Because this *returns* on expiry rather than throwing, a
    ///   caller that depends on the ordering it establishes must re-check
    ///   ``enteredCount`` before continuing. Falling through regardless can park
    ///   the test itself on the gate it was about to open.
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
