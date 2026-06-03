//
//  SearchPlanExecutorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("SearchPlanExecutor")
struct SearchPlanExecutorTests {

    let dataSource: MockNaturalLanguageSearchDataSource
    let executor: SearchPlanExecutor

    init() {
        let dataSource = MockNaturalLanguageSearchDataSource()
        self.dataSource = dataSource
        // Pin "now" to 2026-06-03 so relative-date tests are deterministic.
        let now = NLSFixture.date(year: 2026)
        self.executor = SearchPlanExecutor(dataSource: dataSource, resultLimit: 20, now: { now })
    }

    /// 1. browse + one resolved genre → discover filter carries that genre ID.
    @Test("browse resolves a genre name to its ID")
    func browseResolvesGenre() async throws {
        dataSource.movieGenresResult = [NLSFixture.genre(id: 878, name: "Science Fiction")]
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(SearchPlan(intent: .browse, genres: ["Science Fiction"]))

        let filter = try #require(dataSource.lastMovieFilter)
        #expect(filter.genres == [878])
    }

    /// 2. browse + unknown genre → dropped + degradation.
    @Test("browse records a degradation for an unknown genre")
    func browseUnknownGenre() async throws {
        dataSource.movieGenresResult = [NLSFixture.genre(id: 878, name: "Science Fiction")]
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        let result = try await executor.execute(
            SearchPlan(intent: .browse, genres: ["Nonexistent"], minRating: 5)
        )

        #expect(dataSource.lastMovieFilter?.genres == nil)
        #expect(result.degradations.contains(.unresolvedGenre("Nonexistent")))
    }

    /// 3. decade → year range.
    @Test("decade maps to a year range")
    func decadeMapsToRange() async throws {
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(SearchPlan(intent: .browse, date: .decade(1990)))

        #expect(dataSource.lastMovieFilter?.primaryReleaseYear == .between(start: 1990, end: 1999))
    }

    /// 4. lastNYears against pinned clock.
    @Test("lastNYears resolves against the reference date")
    func lastNYears() async throws {
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(SearchPlan(intent: .browse, date: .lastNYears(5)))

        #expect(dataSource.lastMovieFilter?.primaryReleaseYear == .between(start: 2021, end: 2026))
    }

    /// 5. exact year + runtime + rating.
    @Test("exact year, runtime, and rating map to filter fields")
    func exactYearRuntimeRating() async throws {
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(
            SearchPlan(intent: .browse, date: .exactYear(2019), runtimeMaxMinutes: 120, minRating: 7)
        )

        let filter = try #require(dataSource.lastMovieFilter)
        #expect(filter.primaryReleaseYear == .on(2019))
        #expect(filter.runtimeMax == 120)
        #expect(filter.voteAverageMin == 7)
    }

    /// 6. includeAdult always false.
    @Test("includeAdult is always false")
    func includeAdultAlwaysFalse() async throws {
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(SearchPlan(intent: .browse, minRating: 5))

        #expect(dataSource.lastMovieFilter?.includeAdult == false)
    }

    /// 7 & 8. byPerson resolves people to withCast.
    @Test("byPerson resolves multiple people to withCast")
    func byPersonResolvesPeople() async throws {
        dataSource.searchPeopleResult = [NLSFixture.person(id: 42)]
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(
            SearchPlan(intent: .byPerson, people: ["Tom Hanks", "Tim Allen"])
        )

        // Each name resolves to the mock's single person (id 42).
        #expect(dataSource.lastMovieFilter?.withCast == [42, 42])
        #expect(dataSource.searchPeopleQueries == ["Tom Hanks", "Tim Allen"])
    }

    /// 9. byPerson unresolved person → degradation.
    @Test("byPerson records a degradation for an unresolved person")
    func byPersonUnresolved() async throws {
        dataSource.searchPeopleResult = []
        dataSource.discoverMoviesResult = []

        let result = try await executor.execute(
            SearchPlan(intent: .byPerson, people: ["Nobody"])
        )

        #expect(result.degradations.contains(.unresolvedPerson("Nobody")))
    }

    /// 10. crewRole → people from crew filtered by job.
    @Test("crewRole returns people in the requested role")
    func crewRoleReturnsPeople() async throws {
        dataSource.searchMoviesResult = [NLSFixture.movie(id: 329, title: "Jurassic Park")]
        dataSource.movieCreditsResult = ShowCredits(
            id: 329,
            cast: [],
            crew: [
                NLSFixture.crewMember(id: 488, name: "Steven Spielberg", job: "Director"),
                NLSFixture.crewMember(id: 7, name: "Someone Else", job: "Producer")
            ]
        )

        let result = try await executor.execute(
            SearchPlan(intent: .crewRole, mediaType: .movie, title: "Jurassic Park", crewRole: "Director")
        )

        #expect(result.people.map(\.id) == [488])
        #expect(result.people.first?.name == "Steven Spielberg")
    }

    /// 11. castOf → cast people.
    @Test("castOf returns the cast as people")
    func castOfReturnsPeople() async throws {
        dataSource.searchMoviesResult = [NLSFixture.movie(id: 1, title: "Dune")]
        dataSource.movieCreditsResult = ShowCredits(
            id: 1,
            cast: [
                NLSFixture.castMember(id: 10, name: "Actor One", order: 0),
                NLSFixture.castMember(id: 11, name: "Actor Two", order: 1)
            ],
            crew: []
        )

        let result = try await executor.execute(
            SearchPlan(intent: .castOf, mediaType: .movie, title: "Dune")
        )

        #expect(result.people.map(\.id) == [10, 11])
    }

    /// 12. similar + year window filters in Swift.
    @Test("similar applies a year window in code")
    func similarYearWindow() async throws {
        dataSource.searchMoviesResult = [NLSFixture.movie(id: 550, title: "Fight Club")]
        dataSource.similarMoviesResult = [
            NLSFixture.movie(id: 1, title: "In Range", year: 2014),
            NLSFixture.movie(id: 2, title: "Too Old", year: 1999),
            NLSFixture.movie(id: 3, title: "Too New", year: 2024)
        ]

        let result = try await executor.execute(
            SearchPlan(intent: .similar, title: "Fight Club", date: .decade(2010))
        )

        #expect(result.movies.map(\.id) == [1])
    }

    /// 13. list trending → curatedMovies(.trending).
    @Test("list routes to the curated movie list")
    func listCuratedMovies() async throws {
        dataSource.curatedMoviesResult = [NLSFixture.movie(id: 1)]

        let result = try await executor.execute(
            SearchPlan(intent: .list, mediaType: .movie, list: .trending)
        )

        #expect(dataSource.lastCuratedMovieKind == .trending)
        #expect(result.movies.map(\.id) == [1])
    }

    /// 14. list + person → trending people.
    @Test("list with person media type returns trending people")
    func listTrendingPeople() async throws {
        dataSource.trendingPeopleResult = [NLSFixture.person(id: 5)]

        let result = try await executor.execute(
            SearchPlan(intent: .list, mediaType: .person, list: .trending)
        )

        #expect(result.people.map(\.id) == [5])
    }

    /// 15. company resolution.
    @Test("browse resolves a company name to its ID")
    func companyResolution() async throws {
        dataSource.searchCompaniesResult = [NLSFixture.company(id: 3, name: "Pixar")]
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(SearchPlan(intent: .browse, companies: ["Pixar"]))

        #expect(dataSource.lastMovieFilter?.companies == [3])
    }

    /// 16. exclusions.
    @Test("exclusions remove matching titles and record a degradation")
    func exclusions() async throws {
        dataSource.searchTVSeriesResult = [NLSFixture.tvSeries(id: 1, name: "Star Trek: Picard")]
        dataSource.discoverTVSeriesResult = [
            NLSFixture.tvSeries(id: 1, name: "Star Trek: Picard"),
            NLSFixture.tvSeries(id: 2, name: "Blunt Talk")
        ]
        dataSource.searchPeopleResult = [NLSFixture.person(id: 2387)]

        let result = try await executor.execute(
            SearchPlan(
                intent: .byPerson, mediaType: .tv,
                people: ["Patrick Stewart"], excludeTitles: ["Star Trek"]
            )
        )

        #expect(result.tvSeries.map(\.id) == [2])
        #expect(result.degradations.contains(.excludedTermsApplied(["Star Trek"])))
    }

    /// 17. dedup.
    @Test("results are deduplicated by id")
    func dedup() async throws {
        dataSource.discoverMoviesResult = [
            NLSFixture.movie(id: 1), NLSFixture.movie(id: 1), NLSFixture.movie(id: 2)
        ]

        let result = try await executor.execute(SearchPlan(intent: .browse, minRating: 5))

        #expect(result.movies.map(\.id) == [1, 2])
    }

    /// 18. cap.
    @Test("results are capped at the result limit")
    func cap() async throws {
        dataSource.discoverMoviesResult = (1 ... 50).map { NLSFixture.movie(id: $0) }

        let result = try await executor.execute(SearchPlan(intent: .browse, minRating: 5))

        #expect(result.movies.count == 20)
    }

    /// 19. tv genre uses tv genre list + tv filter.
    @Test("tv browse uses the TV genre list")
    func tvUsesTVGenres() async throws {
        dataSource.tvSeriesGenresResult = [NLSFixture.genre(id: 10765, name: "Sci-Fi & Fantasy")]
        dataSource.discoverTVSeriesResult = [NLSFixture.tvSeries(id: 1)]

        _ = try await executor.execute(
            SearchPlan(intent: .browse, mediaType: .tv, genres: ["Sci-Fi & Fantasy"])
        )

        #expect(dataSource.lastTVFilter?.genres == [10765])
    }

    /// 20. out of scope throws.
    @Test("out-of-scope plan throws")
    func outOfScopeThrows() async throws {
        await #expect(throws: NaturalLanguageSearchError.self) {
            try await executor.execute(SearchPlan(intent: .browse, isInScope: false))
        }
    }

    /// 21. underspecified degrades.
    @Test("an empty browse plan degrades to a popular list")
    func underspecifiedDegrades() async throws {
        dataSource.curatedMoviesResult = [NLSFixture.movie(id: 99)]

        let result = try await executor.execute(SearchPlan(intent: .browse))

        #expect(dataSource.lastCuratedMovieKind == .popular)
        #expect(result.degradations.contains(.underspecified))
        #expect(result.movies.map(\.id) == [99])
    }

    /// 22. mood maps to genres + rating + degradation.
    @Test("mood term maps to genres and a minimum rating")
    func moodMapping() async throws {
        dataSource.movieGenresResult = [
            NLSFixture.genre(id: 35, name: "Comedy"),
            NLSFixture.genre(id: 10751, name: "Family")
        ]
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        let result = try await executor.execute(
            SearchPlan(intent: .mood, moodTerm: "feel-good")
        )

        let filter = try #require(dataSource.lastMovieFilter)
        #expect(filter.genres == [35, 10751])
        #expect(filter.voteAverageMin == 6.5)
        #expect(result.degradations.contains(.moodApproximated("feel-good")))
    }

}
