//
//  WatchProviderService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
    /// [TMDb API - Watch Providers: Available
    /// Regions](https://developer.themoviedb.org/reference/watch-providers-available-regions)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    ///
    func countries(language: String?) async throws -> [Country]

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie
    /// Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Parameters:
    ///    - filter: Watch provider filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
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

public extension WatchProviderService {

    ///
    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Available
    /// Regions](https://developer.themoviedb.org/reference/watch-providers-available-regions)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    ///
    func countries(language: String? = nil) async throws -> [Country] {
        try await countries(language: language)
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie
    /// Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Parameters:
    ///    - filter: Watch provider filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movies.
    ///
    func movieWatchProviders(
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for TV series.
    ///
    func tvSeriesWatchProviders(
        filter: WatchProviderFilter? = nil,
        language: String? = nil
    ) async throws -> [WatchProvider] {
        try await tvSeriesWatchProviders(filter: filter, language: language)
    }

}
