//
//  MediaTests.swift
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
struct MediaTests {

    @Test("id when movie returns movieID")
    func idWhenMovieReturnsMovieID() {
        #expect(media[0].id == 437_342)
    }

    @Test("id when TV series returns tvSeriesID")
    func idWhenTVSeriesReturnsTVSeriesID() {
        #expect(media[1].id == 11366)
    }

    @Test("id when person returns personID")
    func idWhenPersonReturnsPersonID() {
        #expect(media[2].id == 51329)
    }

    @Test("JSON decoding of Media", .tags(.decoding))
    func testDecodeReturnsMedia() throws {
        let result = try JSONDecoder.theMovieDatabase.decode([Media].self, fromResource: "media")

        #expect(result == media)
    }

    private let media: [Media] = [
        .movie(.theFirstOmen),
        .tvSeries(.bigBrother),
        .person(Person(id: 51329, name: "Bradley Cooper", gender: .unknown))
    ]

}
