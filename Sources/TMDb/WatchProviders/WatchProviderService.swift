//
//  WatchProviderService.swift
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
/// Provides an interface for obtaining watch providers from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class WatchProviderService {

    private let apiClient: any APIClient
    private let localeProvider: any LocaleProviding

    ///
    /// Creates a watch provider service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient,
            localeProvider: TMDbFactory.localeProvider()
        )
    }

    init(apiClient: some APIClient, localeProvider: some LocaleProviding) {
        self.apiClient = apiClient
        self.localeProvider = localeProvider
    }

    ///
    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Available Regions](https://developer.themoviedb.org/reference/watch-providers-available-regions)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    ///
    public func countries() async throws -> [Country] {
        let regions: WatchProviderRegions
        do {
            regions = try await apiClient.get(endpoint: WatchProviderEndpoint.regions)
        } catch let error {
            throw TMDbError(error: error)
        }

        return regions.results
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movies.
    ///
    public func movieWatchProviders() async throws -> [WatchProvider] {
        let regionCode = localeProvider.regionCode
        let result: WatchProviderResult
        do {
            result = try await apiClient.get(
                endpoint: WatchProviderEndpoint.movie(regionCode: regionCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for TV series.
    ///
    /// [TMDb API - Watch Providers: TV Providers](https://developer.themoviedb.org/reference/watch-provider-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for TV series.
    ///
    public func tvSeriesWatchProviders() async throws -> [WatchProvider] {
        let regionCode = localeProvider.regionCode
        let result: WatchProviderResult
        do {
            result = try await apiClient.get(
                endpoint: WatchProviderEndpoint.tvSeries(regionCode: regionCode)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

}
