//
//  ChangesService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``ChangesService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over the paginated change-list
/// endpoints, eliminating the need for manual pagination logic.
///
/// The underlying endpoints return a ``ChangedIDCollection``; these sequences surface its page
/// metadata as ``PageableListResult`` pages of ``ChangedID`` so they can reuse the shared
/// pagination primitives.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ChangesService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all movie IDs changed in the given date range across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Returns: An async sequence that yields individual ``ChangedID`` objects.
    ///
    func allMovieChanges(
        startDate: Date? = nil,
        endDate: Date? = nil
    ) -> PagedAsyncSequence<ChangedID> {
        PagedAsyncSequence { [self] page in
            let collection = try await movieChanges(startDate: startDate, endDate: endDate, page: page)
            return PageableListResult(changedIDCollection: collection)
        }
    }

    ///
    /// Returns an async sequence of all TV series IDs changed in the given date range across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Returns: An async sequence that yields individual ``ChangedID`` objects.
    ///
    func allTVSeriesChanges(
        startDate: Date? = nil,
        endDate: Date? = nil
    ) -> PagedAsyncSequence<ChangedID> {
        PagedAsyncSequence { [self] page in
            let collection = try await tvSeriesChanges(startDate: startDate, endDate: endDate, page: page)
            return PageableListResult(changedIDCollection: collection)
        }
    }

    ///
    /// Returns an async sequence of all person IDs changed in the given date range across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Returns: An async sequence that yields individual ``ChangedID`` objects.
    ///
    func allPersonChanges(
        startDate: Date? = nil,
        endDate: Date? = nil
    ) -> PagedAsyncSequence<ChangedID> {
        PagedAsyncSequence { [self] page in
            let collection = try await personChanges(startDate: startDate, endDate: endDate, page: page)
            return PageableListResult(changedIDCollection: collection)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all changed-movie-ID pages for the given date range.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``ChangedID`` objects.
    ///
    func allMovieChangesPages(
        startDate: Date? = nil,
        endDate: Date? = nil
    ) -> PagedPagesAsyncSequence<ChangedID> {
        PagedPagesAsyncSequence { [self] page in
            let collection = try await movieChanges(startDate: startDate, endDate: endDate, page: page)
            return PageableListResult(changedIDCollection: collection)
        }
    }

    ///
    /// Returns an async sequence of all changed-TV-series-ID pages for the given date range.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``ChangedID`` objects.
    ///
    func allTVSeriesChangesPages(
        startDate: Date? = nil,
        endDate: Date? = nil
    ) -> PagedPagesAsyncSequence<ChangedID> {
        PagedPagesAsyncSequence { [self] page in
            let collection = try await tvSeriesChanges(startDate: startDate, endDate: endDate, page: page)
            return PageableListResult(changedIDCollection: collection)
        }
    }

    ///
    /// Returns an async sequence of all changed-person-ID pages for the given date range.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``ChangedID`` objects.
    ///
    func allPersonChangesPages(
        startDate: Date? = nil,
        endDate: Date? = nil
    ) -> PagedPagesAsyncSequence<ChangedID> {
        PagedPagesAsyncSequence { [self] page in
            let collection = try await personChanges(startDate: startDate, endDate: endDate, page: page)
            return PageableListResult(changedIDCollection: collection)
        }
    }

}

private extension PageableListResult where Result == ChangedID {

    init(changedIDCollection collection: ChangedIDCollection) {
        self.init(
            page: collection.page,
            results: collection.results,
            totalResults: collection.totalResults,
            totalPages: collection.totalPages
        )
    }

}
