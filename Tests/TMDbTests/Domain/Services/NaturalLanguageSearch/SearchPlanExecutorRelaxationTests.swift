//
//  SearchPlanExecutorRelaxationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("SearchPlanExecutor (relaxation & resolution)")
struct SearchPlanExecutorRelaxationTests {

    let dataSource: MockNaturalLanguageSearchDataSource
    let executor: SearchPlanExecutor

    init() {
        let dataSource = MockNaturalLanguageSearchDataSource()
        self.dataSource = dataSource
        let now = NLSFixture.date(year: 2026)
        self.executor = SearchPlanExecutor(dataSource: dataSource, resultLimit: 20, now: { now })
    }

    @Test("an empty result is retried with relaxed constraints")
    func relaxesConstraintsOnEmpty() async throws {
        dataSource.searchCompaniesResult = [NLSFixture.company(id: 3, name: "Pixar")]
        // Empty while a company filter is present; non-empty once it's dropped.
        dataSource.discoverMoviesHandler = { filter in
            filter.companies == nil ? [NLSFixture.movie(id: 1)] : []
        }

        let result = try await executor.execute(
            SearchPlan(intent: .browse, mediaType: .movie, companies: ["Pixar"], minRating: 7)
        )

        #expect(result.movies.map(\.id) == [1])
        #expect(result.degradations.contains(.relaxedConstraints))
        #expect(dataSource.discoverMoviesCallCount == 2)
    }

    @Test("relaxation is not reported when every relaxed variant also returns empty")
    func noRelaxedFlagWhenAllVariantsEmpty() async throws {
        dataSource.searchCompaniesResult = [NLSFixture.company(id: 3, name: "Pixar")]
        dataSource.discoverMoviesHandler = { _ in [] } // every ladder level returns nothing

        let result = try await executor.execute(
            SearchPlan(intent: .browse, mediaType: .movie, companies: ["Pixar"], minRating: 7)
        )

        #expect(result.movies.isEmpty)
        #expect(!result.degradations.contains(.relaxedConstraints))
    }

    @Test("a rating-only query is relaxed rather than dead-ending empty")
    func relaxesRatingOnly() async throws {
        // Empty while the rating floor is present; non-empty once it's dropped.
        dataSource.discoverMoviesHandler = { filter in
            filter.voteAverageMin == nil ? [NLSFixture.movie(id: 1)] : []
        }

        let result = try await executor.execute(
            SearchPlan(intent: .browse, mediaType: .movie, minRating: 9)
        )

        #expect(result.movies.map(\.id) == [1])
        #expect(result.degradations.contains(.relaxedConstraints))
        #expect(dataSource.discoverMoviesCallCount == 2)
    }

    @Test("a runtime-only query is relaxed rather than dead-ending empty")
    func relaxesRuntimeOnly() async throws {
        dataSource.discoverMoviesHandler = { filter in
            filter.runtimeMax == nil ? [NLSFixture.movie(id: 1)] : []
        }

        let result = try await executor.execute(
            SearchPlan(intent: .browse, mediaType: .movie, runtimeMaxMinutes: 90)
        )

        #expect(result.movies.map(\.id) == [1])
        #expect(result.degradations.contains(.relaxedConstraints))
        #expect(dataSource.discoverMoviesCallCount == 2)
    }

    @Test("the relaxation ladder drops constraints in order, one step per constraint")
    func relaxationLadderOrdering() {
        let inputs = SearchPlanExecutor.ResolvedInputs(
            genreIDs: [1],
            companyIDs: [2],
            personIDs: [],
            bounds: (from: 1990, to: 1999),
            runtimeMax: 120,
            minRating: 7
        )

        let ladder = SearchPlanExecutor.relaxationLadder(inputs)

        // full, -companies, -bounds, -genres, -rating, -runtime
        #expect(ladder.count == 6)
        #expect(ladder[0].companyIDs == [2])
        #expect(ladder[1].companyIDs.isEmpty)
        #expect(ladder[1].bounds != nil)
        #expect(ladder[2].bounds == nil)
        #expect(ladder[2].genreIDs == [1])
        #expect(ladder[3].genreIDs.isEmpty)
        #expect(ladder[3].minRating == 7)
        #expect(ladder[4].minRating == nil)
        #expect(ladder[4].runtimeMax == 120)
        #expect(ladder[5].runtimeMax == nil)
    }

    @Test("a person-only query is not re-run (person is never relaxed)")
    func relaxationLadderPersonOnly() {
        let inputs = SearchPlanExecutor.ResolvedInputs(
            genreIDs: [],
            companyIDs: [],
            personIDs: [1],
            bounds: nil,
            runtimeMax: nil,
            minRating: nil
        )

        #expect(SearchPlanExecutor.relaxationLadder(inputs).count == 1)
    }

    @Test("an ambiguous title prefers an exact TV match over a fuzzy movie match")
    func ambiguousTitlePrefersExactTVMatch() async throws {
        // "cast of Breaking Bad" — the movie search returns the El Camino film,
        // the TV search returns the series itself; the series should win.
        dataSource.searchMoviesResult = [NLSFixture.movie(id: 1, title: "El Camino: A Breaking Bad Movie")]
        dataSource.searchTVSeriesResult = [NLSFixture.tvSeries(id: 2, name: "Breaking Bad")]
        dataSource.tvSeriesCreditsResult = ShowCredits(
            id: 2,
            cast: [NLSFixture.castMember(id: 10, name: "Bryan Cranston")],
            crew: []
        )
        dataSource.movieCreditsResult = ShowCredits(
            id: 1,
            cast: [NLSFixture.castMember(id: 99, name: "Wrong Movie Cast")],
            crew: []
        )

        let result = try await executor.execute(SearchPlan(intent: .castOf, title: "Breaking Bad"))

        #expect(result.people.map(\.id) == [10])
    }

    @Test("byPerson TV is answered from the person's TV credits, not discover")
    func byPersonTVUsesPersonCredits() async throws {
        dataSource.searchPeopleResult = [NLSFixture.person(id: 42)]
        dataSource.personTVCreditsResult = [
            NLSFixture.tvSeries(id: 1, name: "Breaking Bad"),
            NLSFixture.tvSeries(id: 2, name: "Malcolm in the Middle")
        ]

        let result = try await executor.execute(
            SearchPlan(intent: .byPerson, mediaType: .tv, people: ["Bryan Cranston"])
        )

        #expect(result.tvSeries.map(\.id) == [1, 2])
        #expect(dataSource.personTVCreditsIDs == [42])
        #expect(dataSource.lastTVFilter == nil) // discover/tv (which can't filter by person) is not used
    }

    @Test("a Writer crew role matches a Screenplay job")
    func writerRoleMatchesScreenplayJob() async throws {
        dataSource.searchMoviesResult = [NLSFixture.movie(id: 550, title: "Fight Club")]
        dataSource.movieCreditsResult = ShowCredits(
            id: 550,
            cast: [],
            crew: [NLSFixture.crewMember(id: 1, name: "Jim Uhls", job: "Screenplay")]
        )

        let result = try await executor.execute(
            SearchPlan(intent: .crewRole, mediaType: .movie, title: "Fight Club", crewRole: "Writer")
        )

        #expect(result.people.map(\.id) == [1])
    }

}
