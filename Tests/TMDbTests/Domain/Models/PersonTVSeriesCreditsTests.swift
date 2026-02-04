//
//  PersonTVSeriesCreditsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct PersonTVSeriesCreditsTests {

    @Test("JSON decoding of PersonTVSeriesCredits", .tags(.decoding))
    func decodeReturnsPersonTVSeriesCredits() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonTVSeriesCredits.self, fromResource: "person-tv-series-credits")

        #expect(result.id == personTVSeriesCredits.id)
        #expect(result.cast.count == personTVSeriesCredits.cast.count)
        #expect(result.crew.count == personTVSeriesCredits.crew.count)

        // Verify cast credits
        for (index, castCredit) in result.cast.enumerated() {
            let expected = personTVSeriesCredits.cast[index]
            #expect(castCredit.id == expected.id)
            #expect(castCredit.character == expected.character)
            #expect(castCredit.creditID == expected.creditID)
            #expect(castCredit.episodeCount == expected.episodeCount)
        }

        // Verify crew credits
        for (index, crewCredit) in result.crew.enumerated() {
            let expected = personTVSeriesCredits.crew[index]
            #expect(crewCredit.id == expected.id)
            #expect(crewCredit.job == expected.job)
            #expect(crewCredit.department == expected.department)
            #expect(crewCredit.creditID == expected.creditID)
            #expect(crewCredit.episodeCount == expected.episodeCount)
        }
    }

    @Test("allTVSeries returns combined cast and crew TV series")
    func allTVSeriesReturnsCombinedTVSeries() {
        let castCredit1 = TVSeriesCastCredit.mock(id: 1)
        let castCredit2 = TVSeriesCastCredit.mock(id: 2)
        let crewCredit1 = TVSeriesCrewCredit.mock(id: 1)
        let credits = PersonTVSeriesCredits(
            id: 999, cast: [castCredit1, castCredit2], crew: [crewCredit1]
        )

        let tvSeries1 = TVSeries(
            id: castCredit1.id,
            name: castCredit1.name,
            originalName: castCredit1.originalName,
            originalLanguage: castCredit1.originalLanguage,
            overview: castCredit1.overview,
            firstAirDate: castCredit1.firstAirDate,
            originCountry: castCredit1.originCountries,
            posterPath: castCredit1.posterPath,
            backdropPath: castCredit1.backdropPath,
            popularity: castCredit1.popularity,
            voteAverage: castCredit1.voteAverage,
            voteCount: castCredit1.voteCount,
            isAdultOnly: castCredit1.isAdultOnly
        )
        let tvSeries2 = TVSeries(
            id: castCredit2.id,
            name: castCredit2.name,
            originalName: castCredit2.originalName,
            originalLanguage: castCredit2.originalLanguage,
            overview: castCredit2.overview,
            firstAirDate: castCredit2.firstAirDate,
            originCountry: castCredit2.originCountries,
            posterPath: castCredit2.posterPath,
            backdropPath: castCredit2.backdropPath,
            popularity: castCredit2.popularity,
            voteAverage: castCredit2.voteAverage,
            voteCount: castCredit2.voteCount,
            isAdultOnly: castCredit2.isAdultOnly
        )

        let expectedResult = [tvSeries1, tvSeries2]

        let result = credits.allTVSeries

        #expect(result == expectedResult)
    }

    private let personTVSeriesCredits = PersonTVSeriesCredits(
        id: 287,
        cast: [
            TVSeriesCastCredit(
                id: 54,
                name: "Growing Pains",
                originalName: "Growing Pains",
                originalLanguage: "en",
                // swiftlint:disable:next line_length
                overview: "Growing Pains is an American television sitcom about an affluent family, residing in Huntington, Long Island, New York, with a working mother and a stay-at-home psychiatrist father raising three children together, which aired on ABC from September 24, 1985, to April 25, 1992.",
                genreIDs: [35],
                firstAirDate: DateFormatter.theMovieDatabase.date(from: "1985-09-24"),
                originCountries: ["US"],
                posterPath: URL(string: "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg"),
                backdropPath: URL(string: "/xYpXcp7S8pStWihcksTQQue3jlV.jpg"),
                popularity: 2.883124,
                voteAverage: 6.2,
                voteCount: 25,
                isAdultOnly: nil,
                episodeCount: 2,
                character: "",
                creditID: "525333fb19c295794002c720"
            )
        ],
        crew: [
            TVSeriesCrewCredit(
                id: 69061,
                name: "The OA",
                originalName: "The OA",
                originalLanguage: "en",
                // swiftlint:disable:next line_length
                overview: "Prairie Johnson, blind as a child, comes home to the community she grew up in with her sight restored. Some hail her a miracle, others a dangerous mystery, but Prairie won't talk with the FBI or her parents about the seven years she went missing.",
                genreIDs: [18, 9648, 10765],
                firstAirDate: DateFormatter.theMovieDatabase.date(from: "2016-12-16"),
                originCountries: [],
                posterPath: URL(string: "/ppSiYu2D0nw6KNF0kf5lKDxOGRR.jpg"),
                backdropPath: URL(string: "/k9kPIikcQBzl93nSyXUfqc74J9S.jpg"),
                popularity: 6.990147,
                voteAverage: 7.3,
                voteCount: 121,
                isAdultOnly: nil,
                episodeCount: 8,
                job: "Executive Producer",
                department: "Production",
                creditID: "58cf92ae9251415a7d0339c3"
            )
        ]
    )

}
