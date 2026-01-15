//
//  MediaList.swift
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
/// A model representing a user-created media list.
///
public struct MediaList: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// List identifier.
    ///
    public let id: Int

    ///
    /// List name.
    ///
    public let name: String

    ///
    /// List description.
    ///
    public let description: String?

    ///
    /// Username of the list creator.
    ///
    public let createdBy: String

    ///
    /// ISO 639-1 language code.
    ///
    public let iso6391: String

    ///
    /// Number of items in the list.
    ///
    public let itemCount: Int

    ///
    /// Number of users who have favorited this list.
    ///
    public let favoriteCount: Int

    ///
    /// Poster path for the list.
    ///
    public let posterPath: URL?

    ///
    /// Items in the list.
    ///
    public let items: [MediaListItem]

    ///
    /// Page number.
    ///
    public let page: Int?

    ///
    /// Total number of pages.
    ///
    public let totalPages: Int?

    ///
    /// Total number of results.
    ///
    public let totalResults: Int?

    ///
    /// Creates a media list object.
    ///
    /// - Parameters:
    ///    - id: List identifier.
    ///    - name: List name.
    ///    - description: List description.
    ///    - createdBy: Username of the list creator.
    ///    - iso6391: ISO 639-1 language code.
    ///    - itemCount: Number of items in the list.
    ///    - favoriteCount: Number of users who have favorited this list.
    ///    - posterPath: Poster path for the list.
    ///    - items: Items in the list.
    ///    - page: Page number.
    ///    - totalPages: Total number of pages.
    ///    - totalResults: Total number of results.
    ///
    public init(
        id: Int,
        name: String,
        description: String? = nil,
        createdBy: String,
        iso6391: String,
        itemCount: Int,
        favoriteCount: Int,
        posterPath: URL? = nil,
        items: [MediaListItem] = [],
        page: Int? = nil,
        totalPages: Int? = nil,
        totalResults: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdBy = createdBy
        self.iso6391 = iso6391
        self.itemCount = itemCount
        self.favoriteCount = favoriteCount
        self.posterPath = posterPath
        self.items = items
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }

}
