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

public extension CollectionListItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case originalTitle
        case originalName
        case originalLanguage
        case overview
        case posterPath
        case backdropPath
        case isAdultOnly = "adult"
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// Handles both `title`/`original_title` (from multi search) and
    /// `name`/`original_name` (from collection search and collection
    /// details) keys.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(
            String.self, forKey: .title
        ) ?? container.decode(String.self, forKey: .name)
        self.originalTitle = try container.decodeIfPresent(
            String.self, forKey: .originalTitle
        ) ?? container.decode(String.self, forKey: .originalName)
        self.originalLanguage = try container.decode(
            String.self, forKey: .originalLanguage
        )
        self.overview = try container.decode(
            String.self, forKey: .overview
        )
        self.posterPath = try container.decodeIfPresent(
            URL.self, forKey: .posterPath
        )
        self.backdropPath = try container.decodeIfPresent(
            URL.self, forKey: .backdropPath
        )
        self.isAdultOnly = try container.decodeIfPresent(
            Bool.self, forKey: .isAdultOnly
        )
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(
            originalLanguage, forKey: .originalLanguage
        )
        try container.encode(overview, forKey: .overview)
        try container.encodeIfPresent(
            posterPath, forKey: .posterPath
        )
        try container.encodeIfPresent(
            backdropPath, forKey: .backdropPath
        )
        try container.encodeIfPresent(
            isAdultOnly, forKey: .isAdultOnly
        )
    }

}
