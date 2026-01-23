//
//  PersonExternalLinksCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct PersonExternalLinksCollectionTests {

    @Test("JSON decoding of PersonExternalLinksCollection", .tags(.decoding))
    func decodeReturnsPersonExternalLinksCollection() throws {
        let expectedResult = PersonExternalLinksCollection(
            id: 115_440,
            imdb: IMDbLink(imdbNameID: "nm2858875"),
            wikiData: WikiDataLink(wikiDataID: "Q49561909"),
            facebook: FacebookLink(facebookID: "sydney_sweeney"),
            instagram: InstagramLink(instagramID: "sydney_sweeney"),
            twitter: TwitterLink(twitterID: "sydney_sweeney"),
            tikTok: TikTokLink(tikTokID: "syds_garage")
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonExternalLinksCollection.self,
            fromResource: "person-external-ids"
        )

        #expect(result == expectedResult)
    }

    @Test("JSON encoding and decoding of PersonExternalLinksCollection", .tags(.decoding))
    func encodeAndDecodeReturnsMovieExternalLinksCollection() throws {
        let linksCollection = PersonExternalLinksCollection(
            id: 115_440,
            imdb: IMDbLink(imdbNameID: "nm2858875"),
            wikiData: WikiDataLink(wikiDataID: "Q49561909"),
            facebook: FacebookLink(facebookID: "sydney_sweeney"),
            instagram: InstagramLink(instagramID: "sydney_sweeney"),
            twitter: TwitterLink(twitterID: "sydney_sweeney"),
            tikTok: TikTokLink(tikTokID: "syds_garage")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(linksCollection)

        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonExternalLinksCollection.self, from: data
        )

        #expect(result == linksCollection)
    }

}
