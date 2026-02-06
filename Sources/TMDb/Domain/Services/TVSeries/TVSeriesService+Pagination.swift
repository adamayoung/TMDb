//
//  TVSeriesService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``TVSeriesService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated TV series endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension TVSeriesService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all reviews for a TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``Review`` objects.
    ///
    func allReviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<Review> {
        PagedAsyncSequence { [self] page in
            try await reviews(forTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all recommended TV series for a TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allRecommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await recommendations(forTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all similar TV series for a TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allSimilar(
        toTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await similar(toTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all lists containing a TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Lists](https://developer.themoviedb.org/reference/tv-series-lists)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``Media`` objects.
    ///
    func allLists(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<Media> {
        PagedAsyncSequence { [self] page in
            try await lists(forTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all popular TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured
    /// default language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allPopular(
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await popular(page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series airing today across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Parameters:
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allAiringToday(
        timezone: String? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await airingToday(page: page, timezone: timezone, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series currently on the air across all pages.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Parameters:
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allOnTheAir(
        timezone: String? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await onTheAir(page: page, timezone: timezone, language: language)
        }
    }

    ///
    /// Returns an async sequence of all top rated TV series across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured
    /// default language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allTopRated(
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await topRated(page: page, language: language)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all review pages for a TV series.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``Review`` objects.
    ///
    func allReviewsPages(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<Review> {
        PagedPagesAsyncSequence { [self] page in
            try await reviews(forTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all recommended TV series pages for a TV series.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allRecommendationsPages(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await recommendations(forTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all similar TV series pages for a TV series.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allSimilarPages(
        toTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await similar(toTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all list pages containing a TV series.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series: Lists](https://developer.themoviedb.org/reference/tv-series-lists)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``Media`` objects.
    ///
    func allListsPages(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<Media> {
        PagedPagesAsyncSequence { [self] page in
            try await lists(forTVSeries: tvSeriesID, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all popular TV series pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured
    /// default language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allPopularPages(
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await popular(page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series airing today pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Parameters:
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allAiringTodayPages(
        timezone: String? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await airingToday(page: page, timezone: timezone, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series currently on the air pages.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Parameters:
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allOnTheAirPages(
        timezone: String? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await onTheAir(page: page, timezone: timezone, language: language)
        }
    }

    ///
    /// Returns an async sequence of all top rated TV series pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured
    /// default language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allTopRatedPages(
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await topRated(page: page, language: language)
        }
    }

}
