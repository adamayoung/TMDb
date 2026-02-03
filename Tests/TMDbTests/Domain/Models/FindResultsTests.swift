//
//  FindResultsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct FindResultsTests {

    @Test("JSON decoding of FindResults")
    func decodeReturnsFindResults() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            FindResults.self,
            fromResource: "find-results"
        )

        #expect(result.movieResults.count == findResults.movieResults.count)
        #expect(result.movieResults.first?.id == findResults.movieResults.first?.id)
        #expect(result.personResults == findResults.personResults)
        #expect(result.tvResults == findResults.tvResults)
        #expect(result.tvSeasonResults == findResults.tvSeasonResults)
        #expect(result.tvEpisodeResults == findResults.tvEpisodeResults)
    }

}

extension FindResultsTests {

    private var findResults: FindResults {
        FindResults(
            movieResults: [
                Movie(
                    id: 550,
                    title: "Fight Club",
                    tagline: "How much can you know about yourself if you've never been in a fight?",
                    originalTitle: "Fight Club",
                    originalLanguage: "en",
                    overview:
                    // swiftlint:disable:next line_length
                    "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
                    runtime: 139,
                    genres: [
                        Genre(id: 18, name: "Drama")
                    ],
                    releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-12"),
                    posterPath: nil,
                    backdropPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"),
                    budget: 63_000_000,
                    revenue: 100_853_753,
                    homepageURL: nil,
                    imdbID: "tt0137523",
                    status: .released,
                    productionCompanies: [
                        ProductionCompany(
                            id: 508,
                            name: "Regency Enterprises",
                            originCountry: "US",
                            logoPath: URL(string: "/7PzJdsLGlR7oW4J0J5Xcd0pHGRg.png")
                        )
                    ],
                    productionCountries: [
                        ProductionCountry(
                            countryCode: "US",
                            name: "United States of America"
                        )
                    ],
                    spokenLanguages: [
                        SpokenLanguage(
                            languageCode: "en",
                            name: "English"
                        )
                    ],
                    popularity: 0.5,
                    voteAverage: 7.8,
                    voteCount: 3439,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ],
            personResults: [],
            tvResults: [],
            tvSeasonResults: [],
            tvEpisodeResults: []
        )
    }

}
