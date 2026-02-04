//
//  CollectionListItem.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection list item.
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
    /// Creates a collection list item object.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - title: Collection title.
    ///    - originalTitle: Original collection name.
    ///    - originalLanguage: Original language of the collection.
    ///    - overview: Collection overview.
    ///    - posterPath: Collection poster path.
    ///    - backdropPath: Collection backdrop path.
    ///    - isAdultOnly: Is the collection only suitable for adults.
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
