//
//  TVSeriesExternalLinksCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesExternalLinksCollectionTests {

    @Test("JSON decoding of TVSeriesExternalLinksCollection", .tags(.decoding))
    func decodeReturnsMovieExternalLinksCollection() throws {
        let expectedResult = TVSeriesExternalLinksCollection(
            id: 86423,
            imdb: IMDbLink(imdbTitleID: "tt3007572"),
            wikiData: nil,
            facebook: FacebookLink(facebookID: "lockeandkeynetflix"),
            instagram: InstagramLink(instagramID: "lockeandkeynetflix"),
            twitter: TwitterLink(twitterID: "lockekeynetflix")
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesExternalLinksCollection.self,
            fromResource: "tv-series-external-ids"
        )

        #expect(result == expectedResult)
    }

    @Test("JSON encoding and decoding of TVSeriesExternalLinksCollection", .tags(.decoding))
    func encodeAndDecodeReturnsMovieExternalLinksCollection() throws {
        let linksCollection = TVSeriesExternalLinksCollection(
            id: 86423,
            imdb: IMDbLink(imdbTitleID: "tt3007572"),
            wikiData: nil,
            facebook: FacebookLink(facebookID: "lockeandkeynetflix"),
            instagram: InstagramLink(instagramID: "lockeandkeynetflix"),
            twitter: TwitterLink(twitterID: "lockekeynetflix")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(linksCollection)

        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesExternalLinksCollection.self, from: data
        )

        #expect(result == linksCollection)
    }

}
