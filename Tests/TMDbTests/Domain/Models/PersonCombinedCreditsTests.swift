//
//  PersonCombinedCreditsTests.swift
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

final class PersonCombinedCreditsTests: XCTestCase {

    func testDecodeReturnsPersonCombinedCredits() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonCombinedCredits.self, fromResource: "person-combined-credits")

        XCTAssertEqual(result.id, personCombinedCredits.id)
        XCTAssertEqual(result.cast, personCombinedCredits.cast)
        XCTAssertEqual(result.crew, personCombinedCredits.crew)
    }

    // swiftlint:disable line_length
    private let personCombinedCredits = PersonCombinedCredits(
        id: 287,
        cast: [
            .tvSeries(TVSeries(
                id: 54,
                name: "Growing Pains",
                originalName: "Growing Pains",
                originalLanguage: "en",
                overview: "Growing Pains is an American television sitcom about an affluent family, residing in Huntington, Long Island, New York, with a working mother and a stay-at-home psychiatrist father raising three children together, which aired on ABC from September 24, 1985, to April 25, 1992.",
                firstAirDate: DateFormatter.theMovieDatabase.date(from: "1985-09-24"),
                originCountry: ["US"],
                posterPath: URL(string: "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg"),
                backdropPath: URL(string: "/xYpXcp7S8pStWihcksTQQue3jlV.jpg"),
                popularity: 2.883124,
                voteAverage: 6.2,
                voteCount: 25
            )),
            .movie(Movie(
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
            ))
        ],
        crew: [
            .tvSeries(TVSeries(
                id: 69061,
                name: "The OA",
                originalName: "The OA",
                originalLanguage: "en",
                overview: "Prairie Johnson, blind as a child, comes home to the community she grew up in with her sight restored. Some hail her a miracle, others a dangerous mystery, but Prairie won’t talk with the FBI or her parents about the seven years she went missing.", firstAirDate: DateFormatter.theMovieDatabase.date(from: "2016-12-16"),
                originCountry: [],
                posterPath: URL(string: "/ppSiYu2D0nw6KNF0kf5lKDxOGRR.jpg"),
                backdropPath: URL(string: "/k9kPIikcQBzl93nSyXUfqc74J9S.jpg"),
                popularity: 6.990147,
                voteAverage: 7.3,
                voteCount: 121
            )),
            .movie(Movie(
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
            ))
        ]
    )
    // swiftlint:enable line_length

}
