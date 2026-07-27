//
//  APIConfigurationStore+TestBarrier.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

extension APIConfigurationStore {

    ///
    /// Suspends until at least `count` callers have entered the store, or the
    /// deadline passes.
    ///
    /// A caller that *joins* an in-flight fetch never reaches `FetchGate`, so the
    /// gate cannot observe it. This barrier can, which is what keeps the
    /// coalescing, shared-failure and cancellation tests from depending on
    /// task-start ordering.
    ///
    /// On expiry it records an issue and returns rather than spinning forever, so
    /// a regression fails loudly instead of hanging CI with no diagnostic.
    ///
    func waitUntilCallersEntered(
        atLeast count: Int,
        within timeout: Duration = .seconds(10),
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        let deadline = ContinuousClock.now + timeout

        while entryCount < count {
            guard ContinuousClock.now < deadline else {
                Issue.record(
                    "Only \(entryCount) of \(count) callers entered the store within \(timeout).",
                    sourceLocation: sourceLocation
                )

                return
            }

            await Task.yield()
        }
    }

}
