//
//  WatchProviderService.swift
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
/// Provides an interface for obtaining watch providers from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol WatchProviderService: Sendable {

    ///
    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Available Regions](https://developer.themoviedb.org/reference/watch-providers-available-regions)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    ///
    func countries(language: String?) async throws -> [Country]

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Parameters:
    ///    - filter: Watch provider filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movies.
    ///
    func movieWatchProviders(
        filter: WatchProviderFilter?,
        language: String?
    ) async throws -> [WatchProvider]

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for TV series.
    ///
    /// [TMDb API - Watch Providers: TV Providers](https://developer.themoviedb.org/reference/watch-provider-tv-list)
    ///
    /// - Parameters:
    ///    - filter: Watch provider filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for TV series.
    ///
    func tvSeriesWatchProviders(
        filter: WatchProviderFilter?,
        language: String?
    ) async throws -> [WatchProvider]

}

extension WatchProviderService {

    ///
    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Available Regions](https://developer.themoviedb.org/reference/watch-providers-available-regions)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    ///
    public func countries(language: String? = nil) async throws -> [Country] {
        try await countries(language: language)
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Parameters:
    ///    - filter: Watch provider filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movies.
    ///
    public func movieWatchProviders(
        filter: WatchProviderFilter? = nil,
        language: String? = nil
    ) async throws -> [WatchProvider] {
        try await movieWatchProviders(filter: filter, language: language)
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for TV series.
    ///
    /// [TMDb API - Watch Providers: TV Providers](https://developer.themoviedb.org/reference/watch-provider-tv-list)
    ///
    /// - Parameters:
    ///    - filter: Watch provider filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for TV series.
    ///
    public func tvSeriesWatchProviders(
        filter: WatchProviderFilter? = nil,
        language: String? = nil
    ) async throws -> [WatchProvider] {
        try await tvSeriesWatchProviders(filter: filter, language: language)
    }

}
