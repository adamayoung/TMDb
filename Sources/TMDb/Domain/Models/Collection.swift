//
//  Collection.swift
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
/// A model representing a movie collection.
///
public struct Collection: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Collection name.
    ///
    public let name: String

    ///
    /// Original collection name.
    ///
    public let originalName: String

    ///
    /// Original language of the collection.
    ///
    public let originalLanguage: String

    ///
    /// Collection overview.
    ///
    public let overview: String

    ///
    /// Collection poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Collection backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// Movies in this collection.
    ///
    public let parts: [MovieListItem]

    ///
    /// Creates a collection object.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - name: Collection name.
    ///    - originalName: Original collection name.
    ///    - originalLanguage: Original language of the collection.
    ///    - overview: Collection overview.
    ///    - posterPath: Collection poster path.
    ///    - backdropPath: Collection backdrop path.
    ///    - parts: Movies in this collection.
    ///
    public init(
        id: Int,
        name: String,
        originalName: String,
        originalLanguage: String,
        overview: String,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        parts: [MovieListItem]
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.parts = parts
    }

}

extension Collection {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case originalLanguage
        case overview
        case posterPath
        case backdropPath
        case parts
    }

}
