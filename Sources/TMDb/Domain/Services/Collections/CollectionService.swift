//
//  CollectionService.swift
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
/// Provides an interface for obtaining collections from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol CollectionService: Sendable {

    ///
    /// Returns the primary information about a collection.
    ///
    /// [TMDb API - Collections: Details](https://developer.themoviedb.org/reference/collection-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the collection.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching collection.
    ///
    func details(forCollection id: Collection.ID, language: String?) async throws -> Collection

    ///
    /// Returns the images that belong to a collection.
    ///
    /// [TMDb API - Collections: Images](https://developer.themoviedb.org/reference/collection-images)
    ///
    /// - Parameters:
    ///    - collectionID: The identifier of the collection.
    ///    - languages: ISO 639-1 language codes to filter images. Defaults to all languages.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collection of images for the matching collection.
    ///
    func images(
        forCollection collectionID: Collection.ID,
        languages: [String]?
    ) async throws -> CollectionImageCollection

    ///
    /// Returns the translations that belong to a collection.
    ///
    /// [TMDb API - Collections: Translations](https://developer.themoviedb.org/reference/collection-translations)
    ///
    /// - Parameter collectionID: The identifier of the collection.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Translations for the matching collection.
    ///
    func translations(forCollection collectionID: Collection.ID) async throws
        -> [CollectionTranslation]

}
