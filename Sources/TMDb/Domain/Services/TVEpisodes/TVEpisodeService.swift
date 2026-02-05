//
//  TVEpisodeService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining TV episodes from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol TVEpisodeService: Sendable {

    ///
    /// Returns the primary information about a TV episode.
    ///
    /// [TMDb API - TV Episodes: Details](https://developer.themoviedb.org/reference/tv-episode-details)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV series.
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A episode of the matching TV series.
    ///
    func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVEpisode

    ///
    /// Returns the cast and crew of a TV episode.
    ///
    /// [TMDb API - TV Episode: Credits](https://developer.themoviedb.org/reference/tv-episode-credits)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV series.
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching TV episode.
    ///
    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> ShowCredits

    ///
    /// Returns the images that belong to a TV episode.
    ///
    /// [TMDb API - TV Episode: Images](https://developer.themoviedb.org/reference/tv-episode-images)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV.
    ///    - seasonNumber: The season number of a TV.
    ///    - tvSeriesID: The identifier of the TV.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV's episode.
    ///
    func images(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeImageFilter?
    ) async throws -> TVEpisodeImageCollection

    ///
    /// Returns the videos that belong to a TV series episode.
    ///
    /// [TMDb API - TV Episode: Videos](https://developer.themoviedb.org/reference/tv-episode-videos)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV.
    ///    - seasonNumber: The season number of a TV.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV's episode.
    ///
    func videos(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeVideoFilter?
    ) async throws -> VideoCollection

    ///
    /// Returns the user's account states for a TV episode.
    ///
    /// [TMDb API - TV Episode: Account
    /// States](https://developer.themoviedb.org/reference/tv-episode-account-states)
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number of a TV series.
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The user's account states for the TV episode.
    ///
    func accountStates(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws -> AccountStates

    ///
    /// Adds a rating for a TV episode.
    ///
    /// [TMDb API - TV Episode: Add
    /// Rating](https://developer.themoviedb.org/reference/tv-episode-add-rating)
    ///
    /// - Precondition: `rating` must be between 0.5 and 10.0, in
    ///   increments of 0.5.
    ///
    /// - Parameters:
    ///   - rating: The rating value.
    ///   - episodeNumber: The episode number of a TV series.
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addRating(
        _ rating: Double,
        toEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws

    ///
    /// Deletes the user's rating for a TV episode.
    ///
    /// [TMDb API - TV Episode: Delete
    /// Rating](https://developer.themoviedb.org/reference/tv-episode-delete-rating)
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number of a TV series.
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func deleteRating(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws

    ///
    /// Returns a collection of external links for a TV episode.
    ///
    /// [TMDb API - TV Episode: External
    /// IDs](https://developer.themoviedb.org/reference/tv-episode-external-ids)
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number of a TV series.
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of external links for the TV
    ///   episode.
    ///
    func externalLinks(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVEpisodeExternalLinksCollection

    ///
    /// Returns translations for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Translations](https://developer.themoviedb.org/reference/tv-episode-translations)
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number of a TV series.
    ///   - seasonNumber: The season number of a TV series.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of translations for the TV episode.
    ///
    func translations(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws
        -> TranslationCollection<TVEpisodeTranslationData>

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///   - episodeID: The identifier of the TV episode.
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    func changes(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

}

public extension TVEpisodeService {

    ///
    /// Returns the primary information about a TV episode.
    ///
    /// [TMDb API - TV Episodes: Details](https://developer.themoviedb.org/reference/tv-episode-details)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV series.
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A episode of the matching TV series.
    ///
    func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVEpisode {
        try await details(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            language: language
        )
    }

    ///
    /// Returns the cast and crew of a TV episode.
    ///
    /// [TMDb API - TV Episode: Credits](https://developer.themoviedb.org/reference/tv-episode-credits)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV series.
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching TV episode.
    ///
    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> ShowCredits {
        try await credits(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            language: language
        )
    }

    ///
    /// Returns the images that belong to a TV episode.
    ///
    /// [TMDb API - TV Episode: Images](https://developer.themoviedb.org/reference/tv-episode-images)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV.
    ///    - seasonNumber: The season number of a TV.
    ///    - tvSeriesID: The identifier of the TV.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV's episode.
    ///
    func images(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeImageFilter? = nil
    ) async throws -> TVEpisodeImageCollection {
        try await images(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            filter: filter
        )
    }

    ///
    /// Returns the videos that belong to a TV series episode.
    ///
    /// [TMDb API - TV Episode: Videos](https://developer.themoviedb.org/reference/tv-episode-videos)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV.
    ///    - seasonNumber: The season number of a TV.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV's episode.
    ///
    func videos(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeVideoFilter? = nil
    ) async throws -> VideoCollection {
        try await videos(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            filter: filter
        )
    }

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///   - episodeID: The identifier of the TV episode.
    ///   - startDate: The start date for changes.
    ///   - endDate: The end date for changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    func changes(
        forEpisode episodeID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await changes(
            forEpisode: episodeID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

}
