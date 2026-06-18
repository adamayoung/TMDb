//
//  PrefetchPolicy.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Shared decision for the opt-in lookahead prefetch in ``PagedAsyncSequence``
/// and ``PagedPagesAsyncSequence``, keeping the termination rule in one place.
enum PrefetchPolicy {

    ///
    /// Whether a lookahead prefetch of the next page is worthwhile.
    ///
    /// A prefetch is started only when the total is unknown (keep going until an empty page
    /// terminates the sequence) or the current page is not the last one. The empty-page terminator
    /// itself is the same page a serial scan would fetch, so a prefetch never overshoots a known end
    /// by more than the in-flight page.
    ///
    /// - Parameters:
    ///    - currentPage: The most recently consumed page number.
    ///    - totalPages: The reported total page count, or `nil` when unknown.
    ///
    /// - Returns: `true` if the next page should be prefetched.
    ///
    static func shouldPrefetchNext(currentPage: Int, totalPages: Int?) -> Bool {
        guard let totalPages else {
            return true
        }

        return currentPage < totalPages
    }

}
