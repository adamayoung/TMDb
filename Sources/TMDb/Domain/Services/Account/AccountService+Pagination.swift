//
//  AccountService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Auto-pagination extensions for ``AccountService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated account endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension AccountService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all the user's favourited movies across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allFavouriteMovies(
        sortedBy: FavouriteSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await favouriteMovies(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's favourited TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allFavouriteTVSeries(
        sortedBy: FavouriteSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await favouriteTVSeries(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all movies in the user's watchlist across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allWatchlistMovies(
        sortedBy: WatchlistSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await movieWatchlist(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all TV series in the user's watchlist across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allWatchlistTVSeries(
        sortedBy: WatchlistSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await tvSeriesWatchlist(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all movies rated by the user across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allRatedMovies(
        sortedBy: RatedSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await ratedMovies(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all TV series rated by the user across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allRatedTVSeries(
        sortedBy: RatedSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await ratedTVSeries(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all TV episodes rated by the user across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``TVEpisode`` objects.
    ///
    func allRatedTVEpisodes(
        sortedBy: RatedSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<TVEpisode> {
        PagedAsyncSequence { [self] page in
            try await ratedTVEpisodes(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's custom lists across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields individual ``MediaListSummary`` objects.
    ///
    func allLists(
        accountID: Int,
        session: Session
    ) -> PagedAsyncSequence<MediaListSummary> {
        PagedAsyncSequence { [self] page in
            try await lists(page: page, accountID: accountID, session: session)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all the user's favourited movie pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allFavouriteMoviesPages(
        sortedBy: FavouriteSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await favouriteMovies(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's favourited TV series pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allFavouriteTVSeriesPages(
        sortedBy: FavouriteSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await favouriteTVSeries(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's movie watchlist pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allWatchlistMoviesPages(
        sortedBy: WatchlistSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await movieWatchlist(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's TV series watchlist pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allWatchlistTVSeriesPages(
        sortedBy: WatchlistSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await tvSeriesWatchlist(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's rated movie pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allRatedMoviesPages(
        sortedBy: RatedSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await ratedMovies(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's rated TV series pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allRatedTVSeriesPages(
        sortedBy: RatedSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await ratedTVSeries(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's rated TV episode pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVEpisode`` objects.
    ///
    func allRatedTVEpisodesPages(
        sortedBy: RatedSort? = nil,
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<TVEpisode> {
        PagedPagesAsyncSequence { [self] page in
            try await ratedTVEpisodes(
                sortedBy: sortedBy,
                page: page,
                accountID: accountID,
                session: session
            )
        }
    }

    ///
    /// Returns an async sequence of all the user's custom list pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MediaListSummary`` objects.
    ///
    func allListsPages(
        accountID: Int,
        session: Session
    ) -> PagedPagesAsyncSequence<MediaListSummary> {
        PagedPagesAsyncSequence { [self] page in
            try await lists(page: page, accountID: accountID, session: session)
        }
    }

}

// swiftlint:enable file_length
