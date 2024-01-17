//
//  PersonMovieCreditsTests.swift
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

@testable import TMDb
import XCTest

final class PersonMovieCreditsTests: XCTestCase {

    func testDecodeReturnsPersonMovieCredits() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonMovieCredits.self, fromResource: "person-movie-credits")

        XCTAssertEqual(result.id, personMovieCredits.id)
        XCTAssertEqual(result.cast, personMovieCredits.cast)
        XCTAssertEqual(result.crew, personMovieCredits.crew)
    }

    func testAllShows() {
        let movie1 = Movie(id: 1, title: "Movie 1")
        let movie2 = Movie(id: 2, title: "Movie 2")
        let credits = PersonMovieCredits(id: 999, cast: [movie1, movie2], crew: [movie1])

        let expectedResult = [movie1, movie2]

        let result = credits.allShows

        XCTAssertEqual(result, expectedResult)
    }

    // swiftlint:disable line_length
    private let personMovieCredits = PersonMovieCredits(
        id: 287,
        cast: [
            Movie(
                id: 109_091,
                title: "The Counselor",
                originalTitle: "The Counselor",
                originalLanguage: "en",
                overview: "A rich and successful lawyer named Counselor is about to get married to his fiancée but soon meets up with the middle-man known as Westray who tells him his drug trafficking plan has taken a horrible twist and now he must protect himself and his soon bride-to-be lover as the truth of the drug business uncovers and targets become chosen.",
                releaseDate: DateFormatter.theMovieDatabase.date(from: "2013-10-25"),
                posterPath: URL(string: "/uxp6rHVBzUqZCyTaUI8xzUP5sOf.jpg"),
                backdropPath: URL(string: "/62xHmGnxMi0wV40BS3iKnDru0nO.jpg"),
                popularity: 3.597124,
                voteAverage: 5,
                voteCount: 661,
                hasVideo: false,
                isAdultOnly: false
            )
        ],
        crew: [
            Movie(
                id: 174_349,
                title: "Big Men",
                originalTitle: "Big Men",
                originalLanguage: "en",
                overview: "For her latest industrial exposé, Rachel Boynton (Our Brand Is Crisis) gained unprecedented access to Africa's oil companies. The result is a gripping account of the costly personal tolls levied when American corporate interests pursue oil in places like Ghana and the Niger River Delta. Executive produced by Steven Shainberg and Brad Pitt, Big Men investigates the caustic blend of ambition, corruption and greed that threatens to exacerbate Africa’s resource curse.",
                releaseDate: DateFormatter.theMovieDatabase.date(from: "2014-03-14"),
                posterPath: URL(string: "/q5uKDMl1PXIeMoD10CTbXST7XoN.jpg"),
                backdropPath: URL(string: "/ieWzXfEx3AU9QANrGkbqeXgLeNH.jpg"),
                popularity: 1.214663,
                voteAverage: 6.4,
                voteCount: 7,
                hasVideo: false,
                isAdultOnly: false
            )
        ]
    )
    // swiftlint:enable line_length

}
