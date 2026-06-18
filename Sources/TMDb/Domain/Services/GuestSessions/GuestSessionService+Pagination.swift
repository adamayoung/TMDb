//
//  GuestSessionService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``GuestSessionService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated guest session endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension GuestSessionService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all movies rated by a guest session across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Guest Sessions: Rated Movies](https://developer.themoviedb.org/reference/guest-session-rated-movies)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - guestSessionID: The guest session identifier.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allRatedMovies(
        sortedBy: RatedSort? = nil,
        guestSessionID: String
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await ratedMovies(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
        }
    }

    ///
    /// Returns an async sequence of all TV series rated by a guest session across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Guest Sessions: Rated TV](https://developer.themoviedb.org/reference/guest-session-rated-tv)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - guestSessionID: The guest session identifier.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allRatedTVSeries(
        sortedBy: RatedSort? = nil,
        guestSessionID: String
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await ratedTVSeries(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
        }
    }

    ///
    /// Returns an async sequence of all TV episodes rated by a guest session across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Guest Sessions: Rated TV
    /// Episodes](https://developer.themoviedb.org/reference/guest-session-rated-tv-episodes)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - guestSessionID: The guest session identifier.
    ///
    /// - Returns: An async sequence that yields individual ``TVEpisode`` objects.
    ///
    func allRatedTVEpisodes(
        sortedBy: RatedSort? = nil,
        guestSessionID: String
    ) -> PagedAsyncSequence<TVEpisode> {
        PagedAsyncSequence { [self] page in
            try await ratedTVEpisodes(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all movie pages rated by a guest session.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Guest Sessions: Rated Movies](https://developer.themoviedb.org/reference/guest-session-rated-movies)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - guestSessionID: The guest session identifier.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allRatedMoviesPages(
        sortedBy: RatedSort? = nil,
        guestSessionID: String
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await ratedMovies(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
        }
    }

    ///
    /// Returns an async sequence of all TV series pages rated by a guest session.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Guest Sessions: Rated TV](https://developer.themoviedb.org/reference/guest-session-rated-tv)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - guestSessionID: The guest session identifier.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allRatedTVSeriesPages(
        sortedBy: RatedSort? = nil,
        guestSessionID: String
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await ratedTVSeries(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
        }
    }

    ///
    /// Returns an async sequence of all TV episode pages rated by a guest session.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Guest Sessions: Rated TV
    /// Episodes](https://developer.themoviedb.org/reference/guest-session-rated-tv-episodes)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - guestSessionID: The guest session identifier.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVEpisode`` objects.
    ///
    func allRatedTVEpisodesPages(
        sortedBy: RatedSort? = nil,
        guestSessionID: String
    ) -> PagedPagesAsyncSequence<TVEpisode> {
        PagedPagesAsyncSequence { [self] page in
            try await ratedTVEpisodes(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
        }
    }

}
