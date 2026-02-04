//
//  MediaListSummary.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing summary information about a media list.
///
/// This is returned by endpoints that provide information about which lists contain a media item.
///
public struct MediaListSummary: Identifiable, Codable, Equatable, Hashable, Sendable {

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
    /// Number of items in the list.
    ///
    public let itemCount: Int

    ///
    /// Number of users who have favorited this list.
    ///
    public let favoriteCount: Int

    ///
    /// ISO 639-1 language code.
    ///
    public let iso6391: String?

    ///
    /// ISO 3166-1 country code.
    ///
    public let iso31661: String?

    ///
    /// List type (e.g., "movie", "tv").
    ///
    public let listType: String

    ///
    /// Poster path for the list.
    ///
    public let posterPath: URL?

    ///
    /// Creates a media list summary object.
    ///
    /// - Parameters:
    ///    - id: List identifier.
    ///    - name: List name.
    ///    - description: List description.
    ///    - itemCount: Number of items in the list.
    ///    - favoriteCount: Number of users who have favorited this list.
    ///    - iso6391: ISO 639-1 language code.
    ///    - iso31661: ISO 3166-1 country code.
    ///    - listType: List type (e.g., "movie", "tv").
    ///    - posterPath: Poster path for the list.
    ///
    public init(
        id: Int,
        name: String,
        description: String? = nil,
        itemCount: Int,
        favoriteCount: Int,
        iso6391: String? = nil,
        iso31661: String? = nil,
        listType: String,
        posterPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.itemCount = itemCount
        self.favoriteCount = favoriteCount
        self.iso6391 = iso6391
        self.iso31661 = iso31661
        self.listType = listType
        self.posterPath = posterPath
    }

}
