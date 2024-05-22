//
//  TMDbTVEpisodeService.swift
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

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTVEpisodeService: TVEpisodeService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(
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

    func images(
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

    func videos(
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
