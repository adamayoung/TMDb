//
//  TrendingService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``TrendingService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated trending endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension TrendingService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all trending movies across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allMovies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await movies(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all trending TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allTVSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await tvSeries(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all trending people across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``PersonListItem`` objects.
    ///
    func allPeople(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedAsyncSequence<PersonListItem> {
        PagedAsyncSequence { [self] page in
            try await people(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all trending items (movies, TV series, people) across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TrendingItem`` objects.
    ///
    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedAsyncSequence<TrendingItem> {
        PagedAsyncSequence { [self] page in
            try await allTrending(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all trending movie pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allMoviesPages(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await movies(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all trending TV series pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allTVSeriesPages(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await tvSeries(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all trending people pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``PersonListItem`` objects.
    ///
    func allPeoplePages(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<PersonListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await people(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all trending item pages (movies, TV series, people).
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TrendingItem`` objects.
    ///
    func allTrendingPages(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TrendingItem> {
        PagedPagesAsyncSequence { [self] page in
            try await allTrending(inTimeWindow: timeWindow, page: page, language: language)
        }
    }

}
