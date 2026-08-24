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

    /// `find-results.json` is details-shaped (runtime, budget, genres) and has
    /// every non-movie array empty, so neither the real /find movie shape nor a
    /// populated tvResults had ever been decoded. These two are live captures.
    @Test("JSON decoding of FindResults from a real /find IMDb-ID lookup")
    func decodeReturnsFindResultsForIMDbID() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            FindResults.self,
            fromResource: "find-imdb-id-movie"
        )

        let movie = try #require(result.movieResults.first)
        #expect(result.movieResults.count == 1)
        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
        #expect(movie.originalTitle == "Fight Club")
        #expect(movie.originalLanguage == "en")
        #expect(movie.voteCount == 32615)
        #expect(movie.isAdultOnly == false)

        // /find sends genre_ids, never the expanded `genres` objects, so a
        // movie decoded from this endpoint has no genres and no runtime.
        #expect(movie.genres == nil)
        #expect(movie.runtime == nil)

        #expect(result.personResults.isEmpty)
        #expect(result.tvResults.isEmpty)
        #expect(result.tvSeasonResults.isEmpty)
        #expect(result.tvEpisodeResults.isEmpty)
    }

    @Test("JSON decoding of FindResults from a real /find TVDB-ID lookup")
    func decodeReturnsFindResultsForTVDBID() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            FindResults.self,
            fromResource: "find-tvdb-id-tvshow"
        )

        let tvSeries = try #require(result.tvResults.first)
        #expect(result.tvResults.count == 1)
        #expect(tvSeries.id == 1396)
        #expect(tvSeries.name == "Breaking Bad")
        #expect(tvSeries.originalName == "Breaking Bad")
        #expect(tvSeries.originalLanguage == "en")
        #expect(tvSeries.voteCount == 18371)

        #expect(result.movieResults.isEmpty)
        #expect(result.personResults.isEmpty)
        #expect(result.tvSeasonResults.isEmpty)
        #expect(result.tvEpisodeResults.isEmpty)
    }

    ///
    /// Every other `find-*.json` fixture has `"tv_season_results": []`, so this
    /// array had never decoded a real row — an empty array covers no branch.
    /// It matters now that `TVSeason` carries `showID`: `/find` is the one
    /// endpoint besides tagged images that sends `show_id` on a season, so
    /// without this fixture the property would start populating on a live path
    /// with no test over it.
    ///
    /// Captured from `/find/522572?external_source=tvdb_id` — the same
    /// *True Detective* season 1 the tagged-images fixture uses, reached by a
    /// different endpoint.
    ///
    @Test("JSON decoding of FindResults with a TV season result")
    func decodeReturnsFindResultsWithTVSeasonResult() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            FindResults.self,
            fromResource: "find-tvdb-id-tv-season"
        )

        let tvSeason = try #require(result.tvSeasonResults.first)
        #expect(result.tvSeasonResults.count == 1)
        #expect(tvSeason.id == 59780)
        #expect(tvSeason.name == "Season 1")
        #expect(tvSeason.seasonNumber == 1)
        #expect(tvSeason.showID == 46648)
        #expect(tvSeason.episodeCount == 8)
        #expect(tvSeason.airDate == Date(iso8601: "2014-01-12T00:00:00Z"))

        #expect(result.movieResults.isEmpty)
        #expect(result.personResults.isEmpty)
        #expect(result.tvResults.isEmpty)
        #expect(result.tvEpisodeResults.isEmpty)
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
                    runtime: .seconds(139 * 60),
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
