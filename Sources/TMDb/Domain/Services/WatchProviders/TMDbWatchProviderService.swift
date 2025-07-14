//
//  TMDbWatchProviderService.swift
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
final class TMDbWatchProviderService: WatchProviderService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func countries(language: String? = nil) async throws -> [Country] {
        let request = WatchProviderRegionsRequest(language: language)

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
        let request = WatchProvidersForMoviesRequest(country: filter?.country, language: language)

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
        let request = WatchProvidersForTVSeriesRequest(country: filter?.country, language: language)

        let result: WatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

}
