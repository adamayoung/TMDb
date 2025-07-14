//
//  CollectionListItem.swift
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
/// A model representing a TV series.
///
public struct CollectionListItem: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Collection title.
    ///
    public let title: String

    ///
    /// Original collection title.
    ///
    public let originalTitle: String

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
    /// Is the collection only suitable for adults.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Creates a TV series object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - title: Collection title.
    ///    - originalTitle: Original collection name.
    ///    - originalLanguage: Original language of the collection.
    ///    - overview: Collection overview.
    ///    - posterPath: Collection poster path.
    ///    - backdropPath: Collection backdrop path.
    ///    - isAdultOnly: Is the TV series only suitable for adults.
    ///
    public init(
        id: Int,
        title: String,
        originalTitle: String,
        originalLanguage: String,
        overview: String,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        isAdultOnly: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.isAdultOnly = isAdultOnly
    }

}

extension CollectionListItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle
        case originalLanguage
        case overview
        case posterPath
        case backdropPath
        case isAdultOnly = "adult"
    }

}
