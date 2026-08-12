//
//  MediaList.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
    /// How many items were skipped while decoding this page because their media
    /// type is one this library does not model.
    ///
    /// Decode telemetry, not data: it exists so tests can assert that a page is
    /// short for a known reason rather than a regression. It is zero for a list
    /// built in code.
    ///
    private let droppedItems: DroppedItemCount

    ///
    /// How many items were skipped while decoding this page.
    ///
    package var droppedItemCount: Int {
        droppedItems.value
    }

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
        self.droppedItems = .none
    }

}

extension MediaList {

    /// `.convertFromSnakeCase` hands the decoder the camelCased key, so these raw
    /// values must be spelled that way — `iso6391`, not `iso_639_1`.
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case createdBy
        case iso6391
        case itemCount
        case favoriteCount
        case posterPath
        case items
        case page
        case totalPages
        case totalResults
    }

    ///
    /// Creates a media list by decoding from the given decoder.
    ///
    /// An item whose media type this library does not model is skipped rather
    /// than failing the whole list, and counted internally for tests. Every
    /// other decode failure throws.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.createdBy = try container.decode(String.self, forKey: .createdBy)
        self.iso6391 = try container.decode(String.self, forKey: .iso6391)
        self.itemCount = try container.decode(Int.self, forKey: .itemCount)
        self.favoriteCount = try container.decode(Int.self, forKey: .favoriteCount)
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)

        let decodedItems = try container.decodeSkippingUnknownMediaTypes(
            MediaListItem.self,
            forKey: .items
        )
        self.items = decodedItems.elements
        self.droppedItems = DroppedItemCount(decodedItems.dropped)

        self.page = try container.decodeIfPresent(Int.self, forKey: .page)
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults)
    }

}
