//
//  MovieExternalLinksCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of media databases and social IDs and links for a movie.
///
public struct MovieExternalLinksCollection: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// The TMDb movie identifier.
    ///
    public let id: Movie.ID

    ///
    /// IMDb link.
    ///
    public let imdb: IMDbLink?

    ///
    /// WikiData link.
    ///
    public let wikiData: WikiDataLink?

    ///
    /// Facebook link.
    ///
    public let facebook: FacebookLink?

    ///
    /// Instagram link.
    ///
    public let instagram: InstagramLink?

    ///
    /// Twitter link.
    ///
    public let twitter: TwitterLink?

    ///
    /// Creates an external links collection for a movie.
    ///
    /// - Parameters:
    ///   - id: The TMDb movie identifier.
    ///   - imdb: IMDb link.
    ///   - wikiData: WikiData link.
    ///   - facebook: Facebook link.
    ///   - instagram: Instagram link.
    ///   - twitter: Twitter link.
    ///
    public init(
        id: Movie.ID,
        imdb: IMDbLink? = nil,
        wikiData: WikiDataLink? = nil,
        facebook: FacebookLink? = nil,
        instagram: InstagramLink? = nil,
        twitter: TwitterLink? = nil
    ) {
        self.id = id
        self.imdb = imdb
        self.wikiData = wikiData
        self.facebook = facebook
        self.instagram = instagram
        self.twitter = twitter
    }

}

public extension MovieExternalLinksCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdbId"
        case wikiDataID = "wikidataId"
        case facebookID = "facebookId"
        case instagramID = "instagramId"
        case twitterID = "twitterId"
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested
    /// type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    ///
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Movie.ID.self, forKey: .id)

        let imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        let wikiDataID = try container.decodeIfPresent(String.self, forKey: .wikiDataID)
        let facebookID = try container.decodeIfPresent(String.self, forKey: .facebookID)
        let instagramID = try container.decodeIfPresent(String.self, forKey: .instagramID)
        let twitterID = try container.decodeIfPresent(String.self, forKey: .twitterID)

        let imdbLink = IMDbLink(imdbTitleID: imdbID)
        let wikiDataLink = WikiDataLink(wikiDataID: wikiDataID)
        let facebookLink = FacebookLink(facebookID: facebookID)
        let instagramLink = InstagramLink(instagramID: instagramID)
        let twitterLink = TwitterLink(twitterID: twitterID)

        self.init(
            id: id,
            imdb: imdbLink,
            wikiData: wikiDataLink,
            facebook: facebookLink,
            instagram: instagramLink,
            twitter: twitterLink
        )
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    ///
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(imdb?.id, forKey: .imdbID)
        try container.encodeIfPresent(wikiData?.id, forKey: .wikiDataID)
        try container.encodeIfPresent(facebook?.id, forKey: .facebookID)
        try container.encodeIfPresent(instagram?.id, forKey: .instagramID)
        try container.encodeIfPresent(twitter?.id, forKey: .twitterID)
    }

}
