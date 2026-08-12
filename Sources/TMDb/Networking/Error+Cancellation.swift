//
//  Error+Cancellation.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

extension Error {

    ///
    /// Whether this error represents the **current task** having been cancelled.
    ///
    /// The single source of truth for classifying cancellation, so the two
    /// shapes it arrives in cannot drift apart across the mapping sites:
    ///
    /// - `CancellationError`, raised by `Task.sleep` during `RetryHTTPClient`
    ///   backoff. Only the cancellation machinery raises it, so it needs no
    ///   corroboration.
    /// - A URL-loading cancellation, raised by the transport adapter. This one
    ///   **is** corroborated with `Task.isCancelled`, because
    ///   `URLSession.invalidateAndCancel()` and app teardown raise the same code
    ///   while the calling task is alive — a real failure that must stay
    ///   ``TMDbError/network(_:)`` rather than being silently swallowed by a
    ///   caller's `catch TMDbError.cancelled`. Cancellation is sticky and
    ///   monotone within a task, so the guard cannot under-match a genuine one.
    ///
    /// Matched on domain and code rather than `as? URLError`: on Linux,
    /// swift-corelibs-foundation hands the completion handler an `NSError` in
    /// `NSURLErrorDomain` that does not necessarily bridge to `URLError`.
    ///
    /// - Note: `RetryHTTPClient` deliberately does **not** use this. Its checks
    ///   answer a different question — *should this be retried?* — for which a
    ///   session-initiated cancellation is also a "no", regardless of
    ///   `Task.isCancelled`.
    ///
    var isTaskCancellation: Bool {
        if self is CancellationError {
            return true
        }

        guard Task.isCancelled else {
            return false
        }

        let nsError = self as NSError

        return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled
    }

}
