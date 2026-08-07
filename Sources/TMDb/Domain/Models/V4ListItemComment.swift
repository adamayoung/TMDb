//
//  V4ListItemComment.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model setting the list owner's comment on an item already in a v4 list.
///
/// This is the **only** way to store a comment. TMDb's add-items endpoint also
/// accepts one and answers `success: true`, but silently discards it — so
/// ``V4ListMediaItem``, used when adding, deliberately has no comment field.
///
public struct V4ListItemComment: Codable, Equatable, Hashable, Sendable {

    ///
    /// Whether the item is a movie or a TV series.
    ///
    public let mediaType: ShowType

    ///
    /// The identifier of the movie or TV series.
    ///
    public let mediaID: Int

    ///
    /// The comment to store against the item.
    ///
    public let comment: String

    ///
    /// Creates a v4 list item comment.
    ///
    /// - Parameters:
    ///    - mediaType: Whether the item is a movie or a TV series.
    ///    - mediaID: The identifier of the movie or TV series.
    ///    - comment: The comment to store against the item.
    ///
    public init(mediaType: ShowType, mediaID: Int, comment: String) {
        self.mediaType = mediaType
        self.mediaID = mediaID
        self.comment = comment
    }

}

public extension V4ListItemComment {

    ///
    /// Creates a comment on a movie in a list.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - comment: The comment to store against it.
    ///
    /// - Returns: A comment for that movie.
    ///
    static func movie(_ movieID: Movie.ID, comment: String) -> V4ListItemComment {
        V4ListItemComment(mediaType: .movie, mediaID: movieID, comment: comment)
    }

    ///
    /// Creates a comment on a TV series in a list.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - comment: The comment to store against it.
    ///
    /// - Returns: A comment for that TV series.
    ///
    static func tvSeries(_ tvSeriesID: TVSeries.ID, comment: String) -> V4ListItemComment {
        V4ListItemComment(mediaType: .tvSeries, mediaID: tvSeriesID, comment: comment)
    }

}

extension V4ListItemComment {

    private enum CodingKeys: String, CodingKey {
        case mediaType
        case mediaID = "mediaId"
        case comment
    }

}
