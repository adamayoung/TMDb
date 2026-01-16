//
//  TMDbTVSeasonService.swift
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

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTVSeasonService: TVSeasonService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeason {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        let season: TVSeason
        do {
            season = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return season
    }

    func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeasonAggregateCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonAggregateCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        let credits: TVSeasonAggregateCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        let credits: ShowCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter? = nil
    ) async throws -> TVSeasonImageCollection {
        let request = TVSeasonImagesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        let imageCollection: TVSeasonImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter? = nil
    ) async throws -> VideoCollection {
        let request = TVSeasonVideosRequest(
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
