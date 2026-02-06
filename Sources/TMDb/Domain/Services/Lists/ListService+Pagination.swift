//
//  ListService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``ListService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated list endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ListService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all items in a list across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Lists: Details](https://developer.themoviedb.org/reference/list-details)
    ///
    /// - Parameter listID: The identifier of the list.
    ///
    /// - Returns: An async sequence that yields individual ``MediaListItem`` objects.
    ///
    func allItems(
        forList listID: Int
    ) -> PagedAsyncSequence<MediaListItem> {
        PagedAsyncSequence { [self] page in
            try await items(forList: listID, page: page)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all item pages in a list.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Lists: Details](https://developer.themoviedb.org/reference/list-details)
    ///
    /// - Parameter listID: The identifier of the list.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MediaListItem`` objects.
    ///
    func allItemsPages(
        forList listID: Int
    ) -> PagedPagesAsyncSequence<MediaListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await items(forList: listID, page: page)
        }
    }

}
