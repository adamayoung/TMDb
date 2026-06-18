//
//  PagedAsyncSequence+Prefetch.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Whether a lookahead prefetch of the next page is worthwhile.
///
/// Shared by the opt-in prefetch logic in ``PagedAsyncSequence`` and
/// ``PagedPagesAsyncSequence`` so the termination rule lives in one place: a
/// prefetch is started only when the total is unknown (keep going until an empty
/// page terminates the sequence) or the current page is not the last one. The
/// empty-page terminator itself is the same page a serial scan would fetch, so a
/// prefetch never overshoots a known end by more than the in-flight page.
///
/// - Parameters:
///    - currentPage: The most recently consumed page number.
///    - totalPages: The reported total page count, or `nil` when unknown.
///
/// - Returns: `true` if the next page should be prefetched.
///
func shouldPrefetchNextPage(currentPage: Int, totalPages: Int?) -> Bool {
    guard let totalPages else {
        return true
    }

    return currentPage < totalPages
}
