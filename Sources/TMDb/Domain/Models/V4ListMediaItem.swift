//
//  V4ListMediaItem.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model identifying a movie or TV series to add to, or remove from, a v4
/// list.
///
/// - Note: This deliberately carries **no comment**. TMDb's add-items endpoint
///   accepts a per-item `comment` and answers `success: true`, but never stores
///   it — only updating an existing item persists one. Accepting a comment here
///   would be a parameter that silently does nothing. Use
///   ``V4ListItemComment`` with `updateItems` instead.
///
public struct V4ListMediaItem: Codable, Equatable, Hashable, Sendable {

    ///
    /// Whether the item is a movie or a TV series.
    ///
    public let mediaType: ShowType

    ///
    /// The identifier of the movie or TV series.
    ///
    public let mediaID: Int

    ///
    /// Creates a v4 list media item.
    ///
    /// - Parameters:
    ///    - mediaType: Whether the item is a movie or a TV series.
    ///    - mediaID: The identifier of the movie or TV series.
    ///
    public init(mediaType: ShowType, mediaID: Int) {
        self.mediaType = mediaType
        self.mediaID = mediaID
    }

}

public extension V4ListMediaItem {

    ///
    /// Creates a v4 list media item for a movie.
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Returns: An item identifying that movie.
    ///
    static func movie(_ movieID: Movie.ID) -> V4ListMediaItem {
        V4ListMediaItem(mediaType: .movie, mediaID: movieID)
    }

    ///
    /// Creates a v4 list media item for a TV series.
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Returns: An item identifying that TV series.
    ///
    static func tvSeries(_ tvSeriesID: TVSeries.ID) -> V4ListMediaItem {
        V4ListMediaItem(mediaType: .tvSeries, mediaID: tvSeriesID)
    }

}

extension V4ListMediaItem {

    private enum CodingKeys: String, CodingKey {
        case mediaType
        case mediaID = "mediaId"
    }

}
