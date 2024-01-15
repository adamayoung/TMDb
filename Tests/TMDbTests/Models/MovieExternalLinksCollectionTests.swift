//
//  MovieExternalLinksCollectionTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

@testable import TMDb
import XCTest

final class MovieExternalLinksCollectionTests: XCTestCase {

    func testDecodeReturnsMovieExternalLinksCollection() throws {
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

        XCTAssertEqual(result, expectedResult)
    }

    func testEncodeAndDecodeReturnsMovieExternalLinksCollection() throws {
        let linksCollection = MovieExternalLinksCollection(
            id: 346_698,
            imdb: IMDbLink(imdbTitleID: "tt1517268"),
            wikiData: WikiDataLink(wikiDataID: "Q55436290"),
            facebook: FacebookLink(facebookID: "BarbieTheMovie"),
            instagram: InstagramLink(instagramID: "barbiethemovie"),
            twitter: TwitterLink(twitterID: "barbiethemovie")
        )

        let data = try JSONEncoder.theMovieDatabase.encode(linksCollection)

        let result = try JSONDecoder.theMovieDatabase.decode(MovieExternalLinksCollection.self, from: data)

        XCTAssertEqual(result, linksCollection)
    }

}
