//
//  TVSeasonService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Provides an interface for obtaining TV seasons from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol TVSeasonService: Sendable {

    ///
    /// Returns the primary information about a TV season.
    ///
    /// [TMDb API - TV Seasons: Details](https://developer.themoviedb.org/reference/tv-season-details)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A season of the matching TV series.
    ///
    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVSeason

    ///
    /// Returns the primary information about a TV season with
    /// appended data.
    ///
    /// [TMDb API - TV Seasons: Details](https://developer.themoviedb.org/reference/tv-season-details)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - appending: The additional data to append.
    ///    - language: ISO 639-1 language code to display results
    ///     in. Defaults to the client's configured default
    ///     language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV season with appended data.
    ///
    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeasonAppendOption,
        language: String?
    ) async throws -> TVSeasonDetailsResponse

    ///
    /// Returns the aggregate cast and crew of a TV season.
    ///
    /// This call differs from the main credits call in that it does not return
    /// the newest season. Instead, it is a view of all the entire cast & crew
    /// for all episodes belonging to a TV season.
    ///
    /// [TMDb API - TV Season: Aggregate
    /// Credits](https://developer.themoviedb.org/reference/tv-season-aggregate-credits)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV season.
    ///
    func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVSeasonAggregateCredits

    ///
    /// Returns the cast and crew of a TV season.
    ///
    /// [TMDb API - TV Season: Credits](https://developer.themoviedb.org/reference/tv-season-credits)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching TV season.
    ///
    func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> ShowCredits

    ///
    /// Returns the images that belong to a TV season.
    ///
    /// [TMDb API - TV Seasons: Images](https://developer.themoviedb.org/reference/tv-season-images)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV season.
    ///
    func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter?
    ) async throws -> TVSeasonImageCollection

    ///
    /// Returns the videos that belong to a TV season.
    ///
    /// [TMDb API - TV Seasons: Videos](https://developer.themoviedb.org/reference/tv-season-videos)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV series season.
    ///
    func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter?
    ) async throws -> VideoCollection

    ///
    /// Returns the user's account states for a TV season.
    ///
    /// [TMDb API - TV Season: Account
    /// States](https://developer.themoviedb.org/reference/tv-season-account-states)
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The user's account states for the TV season.
    ///
    func accountStates(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws -> AccountStates

    ///
    /// Returns a collection of external links for a TV season.
    ///
    /// [TMDb API - TV Season: External
    /// IDs](https://developer.themoviedb.org/reference/tv-season-external-ids)
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of external links for the TV season.
    ///
    func externalLinks(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVSeasonExternalLinksCollection

    ///
    /// Returns translations for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Translations](https://developer.themoviedb.org/reference/tv-season-translations)
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of translations for the TV season.
    ///
    func translations(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws
        -> TranslationCollection<TVSeasonTranslationData>

    ///
    /// Returns watch providers for a TV season.
    ///
    /// [TMDb API - TV Season: Watch
    /// Providers](https://developer.themoviedb.org/reference/tv-season-watch-providers)
    ///
    /// Data provided by [JustWatch](https://www.justwatch.com).
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for the TV season grouped by
    ///   country.
    ///
    func watchProviders(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry]

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///   - seasonID: The identifier of the TV season.
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    func changes(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

}

public extension TVSeasonService {

    ///
    /// Returns the primary information about a TV season.
    ///
    /// [TMDb API - TV Seasons: Details](https://developer.themoviedb.org/reference/tv-season-details)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A season of the matching TV series.
    ///
    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeason {
        try await details(forSeason: seasonNumber, inTVSeries: tvSeriesID, language: language)
    }

    ///
    /// Returns the primary information about a TV season with
    /// appended data.
    ///
    /// [TMDb API - TV Seasons: Details](https://developer.themoviedb.org/reference/tv-season-details)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - appending: The additional data to append.
    ///    - language: ISO 639-1 language code to display results
    ///     in. Defaults to the client's configured default
    ///     language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV season with appended data.
    ///
    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeasonAppendOption,
        language: String? = nil
    ) async throws -> TVSeasonDetailsResponse {
        try await details(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            appending: appending,
            language: language
        )
    }

    ///
    /// Returns the aggregate cast and crew of a TV season.
    ///
    /// This call differs from the main credits call in that it does not return
    /// the newest season. Instead, it is a view of all the entire cast & crew
    /// for all episodes belonging to a TV season.
    ///
    /// [TMDb API - TV Season: Aggregate
    /// Credits](https://developer.themoviedb.org/reference/tv-season-aggregate-credits)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV season.
    ///
    func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeasonAggregateCredits {
        try await aggregateCredits(
            forSeason: seasonNumber, inTVSeries: tvSeriesID, language: language
        )
    }

    ///
    /// Returns the cast and crew of a TV season.
    ///
    /// [TMDb API - TV Season: Credits](https://developer.themoviedb.org/reference/tv-season-credits)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching TV season.
    ///
    func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> ShowCredits {
        try await credits(forSeason: seasonNumber, inTVSeries: tvSeriesID, language: language)
    }

    ///
    /// Returns the images that belong to a TV season.
    ///
    /// [TMDb API - TV Seasons: Images](https://developer.themoviedb.org/reference/tv-season-images)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV season.
    ///
    func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter? = nil
    ) async throws -> TVSeasonImageCollection {
        try await images(forSeason: seasonNumber, inTVSeries: tvSeriesID, filter: filter)
    }

    ///
    /// Returns the videos that belong to a TV season.
    ///
    /// [TMDb API - TV Seasons: Videos](https://developer.themoviedb.org/reference/tv-season-videos)
    ///
    /// - Parameters:
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV series season.
    ///
    func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter? = nil
    ) async throws -> VideoCollection {
        try await videos(forSeason: seasonNumber, inTVSeries: tvSeriesID, filter: filter)
    }

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///   - seasonID: The identifier of the TV season.
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    func changes(
        forSeason seasonID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await changes(
            forSeason: seasonID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

}
