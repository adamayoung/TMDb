//
//  PersonExternalLinksCollection.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
/// A model representing a collection of media databases and social IDs and links for a person.
///
public struct PersonExternalLinksCollection: Identifiable, Codable, Equatable, Hashable {

    ///
    /// The TMDb person identifier.
    ///
    public let id: Person.ID

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
    /// TikTok llink.
    ///
    public let tikTok: TikTokLink?

    ///
    /// Creates an external links collection for a movie.
    ///
    /// - Parameters:
    ///   - id: The TMDb person identifier.
    ///   - imdb: IMDb link.
    ///   - wikiData: WikiData link.
    ///   - facebook: Facebook link.
    ///   - instagram: Instagram link.
    ///   - twitter: Twitter link.
    ///   - tikTok: TikTok link.
    ///
    public init(
        id: Movie.ID,
        imdb: IMDbLink? = nil,
        wikiData: WikiDataLink? = nil,
        facebook: FacebookLink? = nil,
        instagram: InstagramLink? = nil,
        twitter: TwitterLink? = nil,
        tikTok: TikTokLink? = nil
    ) {
        self.id = id
        self.imdb = imdb
        self.wikiData = wikiData
        self.facebook = facebook
        self.instagram = instagram
        self.twitter = twitter
        self.tikTok = tikTok
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(imdb?.id)
        hasher.combine(wikiData?.id)
        hasher.combine(facebook?.id)
        hasher.combine(instagram?.id)
        hasher.combine(twitter?.id)
        hasher.combine(tikTok?.id)
    }

    public static func == (lhs: PersonExternalLinksCollection, rhs: PersonExternalLinksCollection) -> Bool {
        lhs.id == rhs.id
            && lhs.imdb == rhs.imdb
            && lhs.wikiData == rhs.wikiData
            && lhs.facebook == rhs.facebook
            && lhs.instagram == rhs.instagram
            && lhs.twitter == rhs.twitter
            && lhs.tikTok == rhs.tikTok
    }

}

public extension PersonExternalLinksCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdbId"
        case wikiDataID = "wikidataId"
        case facebookID = "facebookId"
        case instagramID = "instagramId"
        case twitterID = "twitterId"
        case tikTokID = "tiktokId"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Person.ID.self, forKey: .id)

        let imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        let wikiDataID = try container.decodeIfPresent(String.self, forKey: .wikiDataID)
        let facebookID = try container.decodeIfPresent(String.self, forKey: .facebookID)
        let instagramID = try container.decodeIfPresent(String.self, forKey: .instagramID)
        let twitterID = try container.decodeIfPresent(String.self, forKey: .twitterID)
        let tikTokID = try container.decodeIfPresent(String.self, forKey: .tikTokID)

        let imdbLink = IMDbLink(imdbNameID: imdbID)
        let wikiDataLink = WikiDataLink(wikiDataID: wikiDataID)
        let facebookLink = FacebookLink(facebookID: facebookID)
        let instagramLink = InstagramLink(instagramID: instagramID)
        let twitterLink = TwitterLink(twitterID: twitterID)
        let tikTokLink = TikTokLink(tikTokID: tikTokID)

        self.init(
            id: id,
            imdb: imdbLink,
            wikiData: wikiDataLink,
            facebook: facebookLink,
            instagram: instagramLink,
            twitter: twitterLink,
            tikTok: tikTokLink
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(imdb?.id, forKey: .imdbID)
        try container.encodeIfPresent(wikiData?.id, forKey: .wikiDataID)
        try container.encodeIfPresent(facebook?.id, forKey: .facebookID)
        try container.encodeIfPresent(instagram?.id, forKey: .instagramID)
        try container.encodeIfPresent(twitter?.id, forKey: .twitterID)
        try container.encodeIfPresent(tikTok?.id, forKey: .tikTokID)
    }

}
