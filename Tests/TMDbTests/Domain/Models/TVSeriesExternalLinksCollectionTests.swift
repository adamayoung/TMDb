//
//  TVSeriesExternalLinksCollectionTests.swift
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
            TVSeriesExternalLinksCollection.self, from: data)

        #expect(result == linksCollection)
    }

}
