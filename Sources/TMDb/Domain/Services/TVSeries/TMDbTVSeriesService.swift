//
//  TMDbTVSeriesService.swift
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
final class TMDbTVSeriesService: TVSeriesService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(forTVSeries id: TVSeries.ID, language: String? = nil) async throws -> TVSeries {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesRequest(id: id, language: languageCode)

        let tvSeries: TVSeries
        do {
            tvSeries = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeries
    }

    func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String? = nil) async throws
        -> ShowCredits
    {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesCreditsRequest(id: tvSeriesID, language: languageCode)

        let credits: ShowCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeriesAggregateCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: languageCode)

        let credits: TVSeriesAggregateCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> ReviewPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesReviewsRequest(id: tvSeriesID, page: page, language: languageCode)

        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter? = nil
    ) async throws -> ImageCollection {
        let request = TVSeriesImagesRequest(id: tvSeriesID, languages: filter?.languages)

        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter? = nil
    ) async throws -> VideoCollection {
        let request = TVSeriesVideosRequest(id: tvSeriesID, languages: filter?.languages)

        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesRecommendationsRequest(
            id: tvSeriesID, page: page, language: languageCode)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = SimilarTVSeriesRequest(id: tvSeriesID, page: page, language: languageCode)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func popular(page: Int? = nil, language: String? = nil) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PopularTVSeriesRequest(page: page, language: languageCode)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry] {
        let request = TVSeriesWatchProvidersRequest(id: tvSeriesID)

        let result: ShowWatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
            .map { ShowWatchProvidersByCountry(countryCode: $0.key, watchProviders: $0.value) }
            .sorted { $0.countryCode < $1.countryCode }
    }

    func contentRatings(forTVSeries tvSeriesID: TVSeries.ID) async throws -> [ContentRating] {
        let request = ContentRatingRequest(id: tvSeriesID)

        let result: ContentRatingResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

    func externalLinks(forTVSeries tvSeriesID: TVSeries.ID) async throws
        -> TVSeriesExternalLinksCollection
    {
        let request = TVSeriesExternalLinksRequest(id: tvSeriesID)

        let linksCollection: TVSeriesExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

}
