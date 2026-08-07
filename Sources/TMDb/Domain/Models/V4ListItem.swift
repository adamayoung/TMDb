//
//  V4ListItem.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an item in a v4 list.
///
/// A v4 list holds movies and TV series together, so the media is a ``Show``
/// rather than a movie-shaped model — the v3 `MediaListItem` requires
/// movie-only fields and would silently drop every TV item.
///
public struct V4ListItem: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// The item's identifier — the identifier of the movie or TV series.
    ///
    public var id: Int {
        media.id
    }

    ///
    /// The movie or TV series.
    ///
    public let media: Show

    ///
    /// The list owner's comment on this item, if they have written one.
    ///
    /// - Note: TMDb does not send this alongside the item. It arrives in a
    ///   separate top-level `comments` dictionary and is stitched in when the
    ///   containing ``V4List`` decodes, so an item decoded on its own always
    ///   has a `nil` comment.
    ///
    public let comment: String?

    ///
    /// Creates a v4 list item object.
    ///
    /// - Parameters:
    ///    - media: The movie or TV series.
    ///    - comment: The list owner's comment on this item.
    ///
    public init(media: Show, comment: String? = nil) {
        self.media = media
        self.comment = comment
    }

}

public extension V4ListItem {

    ///
    /// Creates a v4 list item by decoding from the given decoder.
    ///
    /// The same decoder is handed to ``Show``, which reads the `media_type`
    /// discriminator and decodes the movie or TV series shape accordingly.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    init(from decoder: any Decoder) throws {
        self.media = try Show(from: decoder)
        self.comment = nil
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// The media is written in the flat shape TMDb sends, **plus** the
    /// `media_type` discriminator. ``Show`` alone does not write it — neither
    /// `MovieListItem` nor `TVSeriesListItem` has the field — so without this
    /// an encoded item could not be decoded back into a ``Show``, and a round
    /// trip would silently drop every item.
    ///
    /// The comment is deliberately omitted: on the wire it lives in the
    /// containing list's `comments` dictionary, not on the item.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: An error if any values are invalid for the given encoder's
    ///   format.
    ///
    func encode(to encoder: any Encoder) throws {
        try media.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mediaType, forKey: .mediaType)
    }

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private var mediaType: ShowType {
        switch media {
        case .movie:
            .movie

        case .tvSeries:
            .tvSeries
        }
    }

}
