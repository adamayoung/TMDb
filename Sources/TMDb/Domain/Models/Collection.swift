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
//  distributed under the License is distributed on an AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// A model representing a movie collection with full details.
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
    /// Collection overview.
    ///
    public let overview: String?

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
    public let parts: [MovieListItem]?

    ///
    /// Creates a collection object.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - name: Collection name.
    ///    - overview: Collection overview.
    ///    - posterPath: Collection poster path.
    ///    - backdropPath: Collection backdrop path.
    ///    - parts: Movies in this collection.
    ///
    public init(
        id: Int,
        name: String,
        overview: String? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        parts: [MovieListItem]? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.parts = parts
    }

}
