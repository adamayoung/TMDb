//
//  WatchProviderService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Shorter forms of the ``WatchProviderService`` requirements.
///
/// Every one of these **drops** parameters rather than defaulting them, and
/// there is one for each combination a caller can leave out. A defaulted
/// overload would share its requirement's signature — default values are not
/// part of a signature for witness matching — and so would silently become that
/// requirement's default implementation, recursing forever for any conformer
/// that omitted it. `Scripts/check-defaulted-witnesses.py` fails the lint if one
/// is ever added here, and equally if one of these overloads is ever removed:
/// dropping a combination is a source break for anyone calling it.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension WatchProviderService {

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie
    /// Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Parameter filter: Watch provider filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movies.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movieWatchProviders(filter: WatchProviderFilter?) async throws(TMDbError) -> [WatchProvider] {
        try await movieWatchProviders(filter: filter, language: nil)
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie
    /// Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movies.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func movieWatchProviders(language: String?) async throws(TMDbError) -> [WatchProvider] {
        try await movieWatchProviders(filter: nil, language: language)
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie
    /// Providers](https://developer.themoviedb.org/reference/watch-providers-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for movies.
    ///
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movieWatchProviders() async throws(TMDbError) -> [WatchProvider] {
        try await movieWatchProviders(filter: nil, language: nil)
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for TV series.
    ///
    /// [TMDb API - Watch Providers: TV Providers](https://developer.themoviedb.org/reference/watch-provider-tv-list)
    ///
    /// - Parameter filter: Watch provider filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for TV series.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeriesWatchProviders(filter: WatchProviderFilter?) async throws(TMDbError) -> [WatchProvider] {
        try await tvSeriesWatchProviders(filter: filter, language: nil)
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for TV series.
    ///
    /// [TMDb API - Watch Providers: TV Providers](https://developer.themoviedb.org/reference/watch-provider-tv-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Watch providers for TV series.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeriesWatchProviders(language: String?) async throws(TMDbError) -> [WatchProvider] {
        try await tvSeriesWatchProviders(filter: nil, language: language)
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
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesWatchProviders() async throws(TMDbError) -> [WatchProvider] {
        try await tvSeriesWatchProviders(filter: nil, language: nil)
    }

}
