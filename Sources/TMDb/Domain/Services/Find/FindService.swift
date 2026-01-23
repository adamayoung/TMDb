//
//  FindService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for finding movies, TV shows, and people by external IDs.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol FindService: Sendable {

    ///
    /// Finds movies, TV shows, and people by an external ID.
    ///
    /// The supported external sources are: IMDb, Facebook, Instagram, Twitter, TVDB,
    /// TikTok, YouTube, and Wikidata.
    ///
    /// [TMDb API - Find: Find By ID](https://developer.themoviedb.org/reference/find-by-id)
    ///
    /// - Parameters:
    ///   - externalID: The external identifier to search for.
    ///   - externalSource: The external source of the identifier.
    ///   - language: ISO 639-1 language code to display results in. Defaults to the client's
    ///               configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The find results containing any matching movies, TV shows, seasons, episodes,
    ///            or people.
    ///
    func find(
        externalID: String,
        externalSource: ExternalSource,
        language: String?
    ) async throws -> FindResults

}

public extension FindService {

    ///
    /// Finds movies, TV shows, and people by an external ID.
    ///
    /// The supported external sources are: IMDb, Facebook, Instagram, Twitter, TVDB,
    /// TikTok, YouTube, and Wikidata.
    ///
    /// [TMDb API - Find: Find By ID](https://developer.themoviedb.org/reference/find-by-id)
    ///
    /// - Parameters:
    ///   - externalID: The external identifier to search for.
    ///   - externalSource: The external source of the identifier.
    ///   - language: ISO 639-1 language code to display results in. Defaults to the client's
    ///               configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The find results containing any matching movies, TV shows, seasons, episodes,
    ///            or people.
    ///
    func find(
        externalID: String,
        externalSource: ExternalSource,
        language: String? = nil
    ) async throws -> FindResults {
        try await find(externalID: externalID, externalSource: externalSource, language: language)
    }

}
