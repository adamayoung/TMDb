//
//  ReviewTests.swift
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
struct ReviewTests {

    @Test("JSON decoding of Review", .tags(.decoding))
    func decodeReturnsReview() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Review.self, fromResource: "review")

        #expect(result.id == review.id)
        #expect(result.author == review.author)
        #expect(result.content == review.content)
    }

    private let review = Review(
        id: "5488c29bc3a3686f4a00004a",
        author: "Travis Bell",
        content:
            "Like most of the reviews here, I agree that Guardians of the Galaxy was an absolute hoot. Guardians never takes itself too seriously which makes this movie a whole lot of fun. The cast was perfectly chosen and even though two of the main five were CG, knowing who voiced and acted alongside them completely filled out these characters. Guardians of the Galaxy is one of those rare complete audience pleasers. Good fun for everyone!"
    )

}
