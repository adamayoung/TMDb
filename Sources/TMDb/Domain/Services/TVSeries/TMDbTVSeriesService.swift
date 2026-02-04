//
//  TMDbTVSeriesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
    -> ShowCredits {
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

}
