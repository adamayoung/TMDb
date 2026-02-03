//
//  TVSeriesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Provides an interface for obtaining TV series from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol TVSeriesService: Sendable {

    ///
    /// Returns the primary information about a TV series.
    ///
    /// [TMDb API - TV Series: Details](https://developer.themoviedb.org/reference/tv-series-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series.
    ///
    func details(forTVSeries id: TVSeries.ID, language: String?) async throws -> TVSeries

    ///
    /// Returns the cast and crew of a TV series.
    ///
    /// [TMDb API - TV Series: Credits](https://developer.themoviedb.org/reference/tv-series-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String?) async throws -> ShowCredits

    ///
    /// Returns the aggregate cast and crew of a TV series.
    ///
    /// This call differs from the main credits call in that it does not return
    /// the newest season. Instead, it is a view of all the entire cast & crew
    /// for all episodes belonging to a TV series.
    ///
    /// [TMDb API - TV Series: Aggregate
    /// Credits](https://developer.themoviedb.org/reference/tv-series-aggregate-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVSeriesAggregateCredits

    ///
    /// Returns the user reviews for a TV series.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    ///
    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> ReviewPageableList

    ///
    /// Returns the images that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Images](https://developer.themoviedb.org/reference/tv-series-images)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV series.
    ///
    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter?
    ) async throws -> ImageCollection

    ///
    /// Returns the videos that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Videos](https://developer.themoviedb.org/reference/tv-series-videos)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV series.
    ///
    func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter?
    ) async throws -> VideoCollection

    ///
    /// Returns a list of recommended TV series for a TV series.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

    ///
    /// Returns a list of similar TV series for a TV series.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series for get similar TV series for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    ///
    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

    ///
    /// Returns a list current popular TV series.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    func popular(page: Int?, language: String?) async throws -> TVSeriesPageableList

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    func airingToday(page: Int?, timezone: String?, language: String?) async throws
        -> TVSeriesPageableList

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    func onTheAir(page: Int?, timezone: String?, language: String?) async throws
        -> TVSeriesPageableList

    ///
    /// Returns a list of top rated TV series.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated TV series as a pageable list.
    ///
    func topRated(page: Int?, language: String?) async throws -> TVSeriesPageableList

    ///
    /// Returns watch providers for a TV series in all available countries.
    ///
    /// [TMDb API - TVSeries: Watch providers](https://developer.themoviedb.org/reference/tv-series-watch-providers)
    ///
    /// Data provided by [JustWatch](https://www.justwatch.com).
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: Watch providers for the TV series grouped by country.
    ///
    func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry]

    ///
    /// Returns a collection of media databases and social links for a TV series.
    ///
    /// [TMDb API - TVSeries: External IDs](https://developer.themoviedb.org/reference/tv-series-external-ids)
    ///
    /// - Parameters tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of external links for the specificed TV series.
    ///
    func externalLinks(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVSeriesExternalLinksCollection

    ///
    /// Returns the content ratings of a TV series for all available countries.
    ///
    /// [TMDb API - TVSeries: Content ratings](https://developer.themoviedb.org/reference/tv-series-content-ratings)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Content ratings for the TV series grouped by country.
    ///
    func contentRatings(forTVSeries tvSeriesID: TVSeries.ID) async throws -> [ContentRating]

    ///
    /// Returns the user's rating, favorite, and watchlist state for a TV series.
    ///
    /// [TMDb API - TV Series: Account States](https://developer.themoviedb.org/reference/tv-series-account-states)
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The user's account states for the TV series.
    ///
    func accountStates(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws -> AccountStates

    ///
    /// Adds a rating for a TV series.
    ///
    /// [TMDb API - TV Series: Add Rating](https://developer.themoviedb.org/reference/tv-series-add-rating)
    ///
    /// - Precondition: `rating` must be between 0.5 and 10.0, in increments of 0.5.
    ///
    /// - Parameters:
    ///   - rating: The rating value.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addRating(_ rating: Double, toTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws

    ///
    /// Deletes the user's rating for a TV series.
    ///
    /// [TMDb API - TV Series: Delete Rating](https://developer.themoviedb.org/reference/tv-series-delete-rating)
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func deleteRating(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws

    ///
    /// Returns keywords for a TV series.
    ///
    /// [TMDb API - TV Series: Keywords](https://developer.themoviedb.org/reference/tv-series-keywords)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of keywords for the TV series.
    ///
    func keywords(forTVSeries tvSeriesID: TVSeries.ID) async throws -> KeywordCollection

    ///
    /// Returns alternative titles for a TV series.
    ///
    /// [TMDb API - TV Series: Alternative Titles](https://developer.themoviedb.org/reference/tv-series-alternative-titles)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of alternative titles for the TV series.
    ///
    func alternativeTitles(forTVSeries tvSeriesID: TVSeries.ID) async throws -> AlternativeTitleCollection

    ///
    /// Returns translations for a TV series.
    ///
    /// [TMDb API - TV Series: Translations](https://developer.themoviedb.org/reference/tv-series-translations)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of translations for the TV series.
    ///
    func translations(forTVSeries tvSeriesID: TVSeries.ID) async throws
        -> TranslationCollection<TVSeriesTranslationData>

    ///
    /// Returns lists that contain the TV series.
    ///
    /// [TMDb API - TV Series: Lists](https://developer.themoviedb.org/reference/tv-series-lists)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the TV series as a pageable list.
    ///
    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> MediaPageableList

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    ///
    /// Returns the latest TV series added to TMDb.
    ///
    /// [TMDb API - TV Series: Latest](https://developer.themoviedb.org/reference/tv-series-latest-id)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The latest TV series.
    ///
    func latest() async throws -> TVSeries

    ///
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
    ///
    func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection
}

public extension TVSeriesService {

    ///
    /// Returns the primary information about a TV series.
    ///
    /// [TMDb API - TV Series: Details](https://developer.themoviedb.org/reference/tv-series-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series.
    ///
    func details(
        forTVSeries id: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeries {
        try await details(forTVSeries: id, language: language)
    }

    ///
    /// Returns the cast and crew of a TV series.
    ///
    /// [TMDb API - TV Series: Credits](https://developer.themoviedb.org/reference/tv-series-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    func credits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> ShowCredits {
        try await credits(forTVSeries: tvSeriesID, language: language)
    }

    ///
    /// Returns the aggregate cast and crew of a TV series.
    ///
    /// This call differs from the main credits call in that it does not return
    /// the newest season. Instead, it is a view of all the entire cast & crew
    /// for all episodes belonging to a TV series.
    ///
    /// [TMDb API - TV Series: Aggregate
    /// Credits](https://developer.themoviedb.org/reference/tv-series-aggregate-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeriesAggregateCredits {
        try await aggregateCredits(forTVSeries: tvSeriesID, language: language)
    }

    ///
    /// Returns the user reviews for a TV series.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    ///
    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> ReviewPageableList {
        try await reviews(forTVSeries: tvSeriesID, page: page, language: language)
    }

    ///
    /// Returns the images that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Images](https://developer.themoviedb.org/reference/tv-series-images)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV series.
    ///
    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter? = nil
    ) async throws -> ImageCollection {
        try await images(forTVSeries: tvSeriesID, filter: filter)
    }

    ///
    /// Returns the videos that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Videos](https://developer.themoviedb.org/reference/tv-series-videos)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV series.
    ///
    func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter? = nil
    ) async throws -> VideoCollection {
        try await videos(forTVSeries: tvSeriesID, filter: filter)
    }

    ///
    /// Returns a list of recommended TV series for a TV series.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await recommendations(forTVSeries: tvSeriesID, page: page, language: language)
    }

    ///
    /// Returns a list of similar TV series for a TV series.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series for get similar TV series for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    ///
    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await similar(toTVSeries: tvSeriesID, page: page, language: language)
    }

    ///
    /// Returns a list current popular TV series.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    func popular(
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await popular(page: page, language: language)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    func airingToday(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await airingToday(page: page, timezone: timezone, language: language)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    func onTheAir(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await onTheAir(page: page, timezone: timezone, language: language)
    }

    ///
    /// Returns a list of top rated TV series.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated TV series as a pageable list.
    ///
    func topRated(
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await topRated(page: page, language: language)
    }

    ///
    /// Returns lists that contain the TV series.
    ///
    /// [TMDb API - TV Series: Lists](https://developer.themoviedb.org/reference/tv-series-lists)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the TV series as a pageable list.
    ///
    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MediaPageableList {
        try await lists(forTVSeries: tvSeriesID, page: page, language: language)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await changes(
            forTVSeries: tvSeriesID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

    ///
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
    ///
    func changes(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        try await changes(startDate: startDate, endDate: endDate, page: page)
    }

}
