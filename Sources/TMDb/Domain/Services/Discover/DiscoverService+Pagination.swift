//
//  DiscoverService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``DiscoverService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated discover endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension DiscoverService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all movies to be discovered across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allMovies(
        filter: DiscoverMovieFilter? = nil,
        sortedBy: MovieSort? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await movies(filter: filter, sortedBy: sortedBy, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series to be discovered across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allTVSeries(
        filter: DiscoverTVSeriesFilter? = nil,
        sortedBy: TVSeriesSort? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await tvSeries(filter: filter, sortedBy: sortedBy, page: page, language: language)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all movie discovery pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allMoviesPages(
        filter: DiscoverMovieFilter? = nil,
        sortedBy: MovieSort? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await movies(filter: filter, sortedBy: sortedBy, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series discovery pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allTVSeriesPages(
        filter: DiscoverTVSeriesFilter? = nil,
        sortedBy: TVSeriesSort? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await tvSeries(filter: filter, sortedBy: sortedBy, page: page, language: language)
        }
    }

}
