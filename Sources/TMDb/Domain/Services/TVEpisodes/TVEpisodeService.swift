//
//  TVEpisodeService.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
public final class TVEpisodeService {

    private let apiClient: any APIClient

    ///
    /// Creates a TV episode service object.
    ///
    /// - Parameter configuration: A TMDb configuration object.
    ///
    public convenience init(configuration: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(configuration: configuration)
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the primary information about a TV episode.
    ///
    /// [TMDb API - TV Episodes: Details](https://developer.themoviedb.org/reference/tv-episode-details)
    ///
    /// - Parameters:
    ///    - episodeNumber: The episode number of a TV series.
    ///    - seasonNumber: The season number of a TV series.
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
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
        let request = TVEpisodeRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: language
        )

        let episode: TVEpisode
        do {
            episode = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return episode
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
        let request = TVEpisodeImagesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        let imageCollection: TVEpisodeImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
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
        let request = TVEpisodeVideosRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

}
