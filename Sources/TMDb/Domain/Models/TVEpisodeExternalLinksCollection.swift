//
//  TVEpisodeExternalLinksCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of media databases and social
/// IDs and links for a TV episode.
///
public struct TVEpisodeExternalLinksCollection: Identifiable,
Codable, Equatable, Hashable, Sendable {

    ///
    /// The TMDb TV episode identifier.
    ///
    public let id: Int

    ///
    /// IMDb link.
    ///
    public let imdb: IMDbLink?

    ///
    /// WikiData link.
    ///
    public let wikiData: WikiDataLink?

    ///
    /// Creates an external links collection for a TV episode.
    ///
    /// - Parameters:
    ///   - id: The TMDb TV episode identifier.
    ///   - imdb: IMDb link.
    ///   - wikiData: WikiData link.
    ///
    public init(
        id: Int,
        imdb: IMDbLink? = nil,
        wikiData: WikiDataLink? = nil
    ) {
        self.id = id
        self.imdb = imdb
        self.wikiData = wikiData
    }

}

public extension TVEpisodeExternalLinksCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdbId"
        case wikiDataID = "wikidataId"
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder
    /// fails, or if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered
    ///   encoded value is not convertible to the requested type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have
    ///   an entry for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null
    ///   entry for the given key.
    ///
    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        let id = try container.decode(Int.self, forKey: .id)

        let imdbID = try container.decodeIfPresent(
            String.self,
            forKey: .imdbID
        )
        let wikiDataID = try container.decodeIfPresent(
            String.self,
            forKey: .wikiDataID
        )

        let imdbLink = IMDbLink(imdbTitleID: imdbID)
        let wikiDataLink = WikiDataLink(wikiDataID: wikiDataID)

        self.init(
            id: id,
            imdb: imdbLink,
            wikiData: wikiDataLink
        )
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode
    /// an empty keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for
    /// the given encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: `EncodingError.invalidValue` if the given value is
    ///   invalid in the current context for this format.
    ///
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(
            keyedBy: CodingKeys.self
        )

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(
            imdb?.id,
            forKey: .imdbID
        )
        try container.encodeIfPresent(
            wikiData?.id,
            forKey: .wikiDataID
        )
    }

}
