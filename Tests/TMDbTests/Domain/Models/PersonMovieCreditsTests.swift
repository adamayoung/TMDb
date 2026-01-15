//
//  PersonMovieCreditsTests.swift
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
struct PersonMovieCreditsTests {

    @Test("JSON decoding of PersonMovieCredits", .tags(.decoding))
    func decodeReturnsPersonMovieCredits() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonMovieCredits.self, fromResource: "person-movie-credits")

        #expect(result.id == personMovieCredits.id)
        #expect(result.cast.count == personMovieCredits.cast.count)
        #expect(result.crew.count == personMovieCredits.crew.count)

        // Verify cast credits
        for (index, castCredit) in result.cast.enumerated() {
            let expected = personMovieCredits.cast[index]
            #expect(castCredit.id == expected.id)
            #expect(castCredit.character == expected.character)
            #expect(castCredit.creditID == expected.creditID)
            #expect(castCredit.order == expected.order)
        }

        // Verify crew credits
        for (index, crewCredit) in result.crew.enumerated() {
            let expected = personMovieCredits.crew[index]
            #expect(crewCredit.id == expected.id)
            #expect(crewCredit.job == expected.job)
            #expect(crewCredit.department == expected.department)
            #expect(crewCredit.creditID == expected.creditID)
        }
    }

    @Test("allShows returns combined cast and crew movies")
    func allShowsReturnsCombinedMovies() {
        let castCredit1 = MovieCastCredit.mock(id: 1)
        let castCredit2 = MovieCastCredit.mock(id: 2)
        let crewCredit1 = MovieCrewCredit.mock(id: 1)
        let credits = PersonMovieCredits(
            id: 999, cast: [castCredit1, castCredit2], crew: [crewCredit1])

        let movie1 = Movie(
            id: castCredit1.id,
            title: castCredit1.title,
            originalTitle: castCredit1.originalTitle,
            originalLanguage: castCredit1.originalLanguage,
            overview: castCredit1.overview,
            releaseDate: castCredit1.releaseDate,
            posterPath: castCredit1.posterPath,
            backdropPath: castCredit1.backdropPath,
            popularity: castCredit1.popularity,
            voteAverage: castCredit1.voteAverage,
            voteCount: castCredit1.voteCount,
            hasVideo: castCredit1.hasVideo,
            isAdultOnly: castCredit1.isAdultOnly
        )
        let movie2 = Movie(
            id: castCredit2.id,
            title: castCredit2.title,
            originalTitle: castCredit2.originalTitle,
            originalLanguage: castCredit2.originalLanguage,
            overview: castCredit2.overview,
            releaseDate: castCredit2.releaseDate,
            posterPath: castCredit2.posterPath,
            backdropPath: castCredit2.backdropPath,
            popularity: castCredit2.popularity,
            voteAverage: castCredit2.voteAverage,
            voteCount: castCredit2.voteCount,
            hasVideo: castCredit2.hasVideo,
            isAdultOnly: castCredit2.isAdultOnly
        )

        let expectedResult = [movie1, movie2]

        let result = credits.allShows

        #expect(result == expectedResult)
    }

    private let personMovieCredits = PersonMovieCredits(
        id: 287,
        cast: [
            MovieCastCredit(
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
                order: 2
            )
        ],
        crew: [
            MovieCrewCredit(
                id: 174_349,
                title: "Big Men",
                originalTitle: "Big Men",
                originalLanguage: "en",
                overview:
                    "For her latest industrial exposé, Rachel Boynton (Our Brand Is Crisis) gained unprecedented access to Africa's oil companies. The result is a gripping account of the costly personal tolls levied when American corporate interests pursue oil in places like Ghana and the Niger River Delta. Executive produced by Steven Shainberg and Brad Pitt, Big Men investigates the caustic blend of ambition, corruption and greed that threatens to exacerbate Africa's resource curse.",
                genreIDs: [99],
                releaseDate: DateFormatter.theMovieDatabase.date(from: "2014-03-14"),
                posterPath: URL(string: "/q5uKDMl1PXIeMoD10CTbXST7XoN.jpg"),
                backdropPath: URL(string: "/ieWzXfEx3AU9QANrGkbqeXgLeNH.jpg"),
                popularity: 1.214663,
                voteAverage: 6.4,
                voteCount: 7,
                hasVideo: false,
                isAdultOnly: false,
                job: "Executive Producer",
                department: "Production",
                creditID: "52fe4d49c3a36847f8258cf3"
            )
        ]
    )

}
