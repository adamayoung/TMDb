//
//  FindService.swift
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

extension FindService {

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
    public func find(
        externalID: String,
        externalSource: ExternalSource,
        language: String? = nil
    ) async throws -> FindResults {
        try await find(externalID: externalID, externalSource: externalSource, language: language)
    }

}
