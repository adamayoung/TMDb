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
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Provides an interface for finding content by external IDs.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol FindService: Sendable {

    ///
    /// Find movies, TV shows, and people by external ID.
    ///
    /// [TMDb API - Find: Find by ID](https://developer.themoviedb.org/reference/find-by-id)
    ///
    /// - Parameters:
    ///    - externalID: The external ID (e.g., IMDb ID, TVDB ID).
    ///    - externalSource: The external source type.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Find results containing movies, TV shows, episodes, and people.
    ///
    func find(
        externalID: String,
        externalSource: ExternalSource,
        language: String?
    ) async throws -> FindResults

}

extension FindService {

    ///
    /// Find movies, TV shows, and people by external ID.
    ///
    /// [TMDb API - Find: Find by ID](https://developer.themoviedb.org/reference/find-by-id)
    ///
    /// - Parameters:
    ///    - externalID: The external ID (e.g., IMDb ID, TVDB ID).
    ///    - externalSource: The external source type.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Find results containing movies, TV shows, episodes, and people.
    ///
    public func find(
        externalID: String,
        externalSource: ExternalSource,
        language: String? = nil
    ) async throws -> FindResults {
        try await find(externalID: externalID, externalSource: externalSource, language: language)
    }

}

///
/// External source types for finding content.
///
public enum ExternalSource: String, Codable, Sendable {
    /// IMDb ID
    case imdb = "imdb_id"
    /// Facebook ID
    case facebook = "facebook_id"
    /// Instagram ID
    case instagram = "instagram_id"
    /// TVDB ID
    case tvdb = "tvdb_id"
    /// Twitter/X ID
    case twitter = "twitter_id"
}
