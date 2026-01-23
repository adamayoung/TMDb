//
//  TMDbWatchProviderService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbWatchProviderService: WatchProviderService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func countries(language: String? = nil) async throws -> [Country] {
        let languageCode = language ?? configuration.defaultLanguage
        let request = WatchProviderRegionsRequest(language: languageCode)

        let regions: WatchProviderRegions
        do {
            regions = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return regions.results
    }

    func movieWatchProviders(
        filter: WatchProviderFilter? = nil,
        language: String? = nil
    ) async throws -> [WatchProvider] {
        let languageCode = language ?? configuration.defaultLanguage
        let request = WatchProvidersForMoviesRequest(
            country: filter?.country, language: languageCode
        )

        let result: WatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

    func tvSeriesWatchProviders(
        filter: WatchProviderFilter? = nil,
        language: String? = nil
    ) async throws -> [WatchProvider] {
        let languageCode = language ?? configuration.defaultLanguage
        let request = WatchProvidersForTVSeriesRequest(
            country: filter?.country, language: languageCode
        )

        let result: WatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

}
