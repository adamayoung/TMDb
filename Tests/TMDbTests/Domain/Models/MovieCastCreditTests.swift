//
//  MovieCastCreditTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
struct MovieCastCreditTests {

    @Test("JSON decoding of MovieCastCredit", .tags(.decoding))
    func decodeReturnsMovieCastCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieCastCredit.self, fromResource: "movie-cast-credit")

        #expect(result == credit)
    }

}

extension MovieCastCreditTests {

    private var credit: MovieCastCredit {
        .init(
            id: 109_091,
            title: "The Counselor",
            originalTitle: "The Counselor",
            originalLanguage: "en",
            overview:
                "A rich and successful lawyer named Counselor is about to get married to his fiancée but soon meets up with the middle-man known as Westray who tells him his drug trafficking plan has taken a horrible twist and now he must protect himself and his soon bride-to-be lover as the truth of the drug business uncovers and targets become chosen.",
            genreIDs: [80, 18, 53],
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2013-10-25"),
            posterPath: URL(string: "/uxp6rHVBzUqZCyTaUI8xzUP5sOf.jpg"),
            backdropPath: URL(string: "/62xHmGnxMi0wV40BS3iKnDru0nO.jpg"),
            popularity: 3.597124,
            voteAverage: 5,
            voteCount: 661,
            hasVideo: false,
            isAdultOnly: false,
            character: "Westray",
            creditID: "52fe4aaac3a36847f81db47d",
            order: 0
        )
    }

}
