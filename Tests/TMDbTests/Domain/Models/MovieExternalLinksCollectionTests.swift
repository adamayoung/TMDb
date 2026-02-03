//
//  MovieExternalLinksCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MovieExternalLinksCollectionTests {

    @Test("JSON decoding of MovieExternalLinksCollection", .tags(.decoding))
    func decodeReturnsMovieExternalLinksCollection() throws {
        let expectedResult = MovieExternalLinksCollection(
            id: 346_698,
            imdb: IMDbLink(imdbTitleID: "tt1517268"),
            wikiData: WikiDataLink(wikiDataID: "Q55436290"),
            facebook: FacebookLink(facebookID: "BarbieTheMovie"),
            instagram: InstagramLink(instagramID: "barbiethemovie"),
            twitter: TwitterLink(twitterID: "barbiethemovie")
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieExternalLinksCollection.self,
            fromResource: "movie-external-ids"
        )

        #expect(result == expectedResult)
    }

    @Test("JSON encoding and decoding of MovieExternalLinksCollection", .tags(.decoding))
    func encodeAndDecodeReturnsMovieExternalLinksCollection() throws {
        let linksCollection = MovieExternalLinksCollection(
            id: 346_698,
            imdb: IMDbLink(imdbTitleID: "tt1517268"),
            wikiData: WikiDataLink(wikiDataID: "Q55436290"),
            facebook: FacebookLink(facebookID: "BarbieTheMovie"),
            instagram: InstagramLink(instagramID: "barbiethemovie"),
            twitter: TwitterLink(twitterID: "barbiethemovie")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(linksCollection)

        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieExternalLinksCollection.self, from: data
        )

        #expect(result == linksCollection)
    }

}
