//
//  TVEpisodeService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
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

}

extension TVEpisodeService {

    ///
    /// Returns the primary information about a TV episode.
    ///
    /// [TMDb API - TV Episodes: Details](https://developer.themoviedb.org/reference/tv-episode-details)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV series.
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A episode of the matching TV series.
    ///
    public func details(
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Credits for the matching TV episode.
    ///
    public func credits(
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
    public func images(
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
    public func videos(
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

}
