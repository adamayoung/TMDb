//
//  NaturalLanguageSearchReviewTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("SearchPlanExecutor (review coverage)")
struct SearchPlanExecutorReviewTests {

    let dataSource: MockNaturalLanguageSearchDataSource
    let executor: SearchPlanExecutor

    init() {
        let dataSource = MockNaturalLanguageSearchDataSource()
        self.dataSource = dataSource
        let now = NLSFixture.date(year: 2026)
        self.executor = SearchPlanExecutor(dataSource: dataSource, resultLimit: 20, now: { now })
    }

    @Test("byPerson with an unresolvable sole person degrades instead of a broad discover")
    func byPersonAllUnresolvedDegrades() async throws {
        dataSource.searchPeopleResult = []
        dataSource.curatedMoviesResult = [NLSFixture.movie(id: 99)]

        let result = try await executor.execute(SearchPlan(intent: .byPerson, people: ["Nobody"]))

        #expect(result.degradations.contains(.unresolvedPerson("Nobody")))
        #expect(result.degradations.contains(.underspecified))
        #expect(dataSource.lastMovieFilter == nil) // no unconstrained discover was issued
        #expect(dataSource.lastCuratedMovieKind == .popular)
    }

    @Test("thisYear and recent resolve to the right bounds")
    func thisYearAndRecentBounds() async throws {
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(SearchPlan(intent: .browse, date: .thisYear))
        #expect(dataSource.lastMovieFilter?.primaryReleaseYear == .on(2026))

        _ = try await executor.execute(SearchPlan(intent: .browse, date: .recent))
        #expect(dataSource.lastMovieFilter?.primaryReleaseYear == .between(start: 2025, end: 2026))
    }

    @Test("byPerson with a crew role populates withCrew, not withCast")
    func byPersonCrewRole() async throws {
        dataSource.searchPeopleResult = [NLSFixture.person(id: 42)]
        dataSource.discoverMoviesResult = [NLSFixture.movie(id: 1)]

        _ = try await executor.execute(
            SearchPlan(intent: .byPerson, people: ["Spielberg"], crewRole: "Director")
        )

        #expect(dataSource.lastMovieFilter?.withCrew == [42])
        #expect(dataSource.lastMovieFilter?.withCast == nil)
    }

    @Test("a movie-only genre is dropped on a TV plan")
    func movieGenreDroppedOnTVPlan() async throws {
        dataSource.movieGenresResult = [NLSFixture.genre(id: 878, name: "Science Fiction")]
        dataSource.tvSeriesGenresResult = [NLSFixture.genre(id: 18, name: "Drama")]
        dataSource.discoverTVSeriesResult = [NLSFixture.tvSeries(id: 1)]

        let result = try await executor.execute(
            SearchPlan(intent: .browse, mediaType: .tv, genres: ["Science Fiction"], minRating: 7)
        )

        #expect(dataSource.lastTVFilter?.genres == nil)
        #expect(result.degradations.contains(.unresolvedGenre("Science Fiction")))
    }

    @Test("TV similar applies a year window in code")
    func tvSimilarYearWindow() async throws {
        dataSource.searchTVSeriesResult = [NLSFixture.tvSeries(id: 1, name: "GoT")]
        dataSource.similarTVSeriesResult = [
            NLSFixture.tvSeries(id: 10, name: "In Range", year: 2015),
            NLSFixture.tvSeries(id: 11, name: "Too Old", year: 1999)
        ]

        let result = try await executor.execute(
            SearchPlan(intent: .similar, mediaType: .tv, title: "GoT", date: .decade(2010))
        )

        #expect(result.tvSeries.map(\.id) == [10])
    }

    @Test("an incoherent list plan ignores the irrelevant title operand")
    func incoherentListIgnoresTitle() async throws {
        dataSource.curatedMoviesResult = [NLSFixture.movie(id: 1)]

        let result = try await executor.execute(
            SearchPlan(intent: .list, mediaType: .movie, title: "Some Movie", list: .popular)
        )

        #expect(dataSource.lastCuratedMovieKind == .popular)
        #expect(result.movies.map(\.id) == [1])
    }

    @Test("castOf deduplicates a person appearing twice in the cast")
    func castOfDeduplicates() async throws {
        dataSource.searchMoviesResult = [NLSFixture.movie(id: 1, title: "Dune")]
        dataSource.movieCreditsResult = ShowCredits(
            id: 1,
            cast: [
                NLSFixture.castMember(id: 10, name: "Actor", order: 0),
                NLSFixture.castMember(id: 10, name: "Actor", order: 1)
            ],
            crew: []
        )

        let result = try await executor.execute(
            SearchPlan(intent: .castOf, mediaType: .movie, title: "Dune")
        )

        #expect(result.people.map(\.id) == [10])
    }

    @Test("find returns movies, TV series, and people for a bare query")
    func findReturnsAllTypes() async throws {
        dataSource.searchAllResult = (
            [NLSFixture.movie(id: 1, title: "Fight Club")],
            [NLSFixture.tvSeries(id: 2, name: "Some Show")],
            [NLSFixture.person(id: 3, name: "Some Person")]
        )

        let result = try await executor.execute(SearchPlan(intent: .find, title: "Fight Club"))

        #expect(result.movies.map(\.id) == [1])
        #expect(result.tvSeries.map(\.id) == [2])
        #expect(result.people.map(\.id) == [3])
        #expect(dataSource.searchAllQueries == ["Fight Club"])
    }

    @Test("find with no title returns empty without calling search")
    func findEmptyTitleReturnsEmpty() async throws {
        let result = try await executor.execute(SearchPlan(intent: .find))

        #expect(result.movies.isEmpty)
        #expect(result.tvSeries.isEmpty)
        #expect(result.people.isEmpty)
        #expect(dataSource.searchAllQueries.isEmpty)
    }

    @Test("find narrows to a single bucket when a media type is given")
    func findNarrowsByMediaType() async throws {
        dataSource.searchAllResult = (
            [NLSFixture.movie(id: 1)],
            [NLSFixture.tvSeries(id: 2, name: "Breaking Bad")],
            [NLSFixture.person(id: 3)]
        )

        let tv = try await executor.execute(
            SearchPlan(intent: .find, mediaType: .tv, title: "Breaking Bad")
        )
        #expect(tv.tvSeries.map(\.id) == [2])
        #expect(tv.movies.isEmpty)
        #expect(tv.people.isEmpty)

        let people = try await executor.execute(
            SearchPlan(intent: .find, mediaType: .person, title: "Tom Hanks")
        )
        #expect(people.people.map(\.id) == [3])
        #expect(people.movies.isEmpty)
        #expect(people.tvSeries.isEmpty)
    }

}

@Suite("TMDbNaturalLanguageSearchService (review coverage)")
struct TMDbNaturalLanguageSearchServiceReviewTests {

    let planner = MockSearchPlanGenerator()
    let dataSource = MockNaturalLanguageSearchDataSource()

    private func makeService() -> TMDbNaturalLanguageSearchService {
        TMDbNaturalLanguageSearchService(
            planner: planner,
            executor: SearchPlanExecutor(dataSource: dataSource),
            dataSource: dataSource
        )
    }

    @Test("unsupported language is rethrown and not rescued by the fallback")
    func unsupportedLanguageRethrown() async throws {
        planner.planError = .unsupportedLanguage

        await #expect(throws: NaturalLanguageSearchError.unsupportedLanguage) {
            try await makeService().search(matching: "x")
        }
        #expect(dataSource.searchAllQueries.isEmpty)
    }

    @Test("a decoding planning failure falls back to a literal search")
    func planningFailedFallsBack() async throws {
        planner.planError = .planningFailed(underlying: nil)
        dataSource.searchAllResult = ([NLSFixture.movie(id: 1)], [], [])

        let result = try await makeService().search(matching: "x")

        #expect(result.degradations.contains(.planRejectedUsedLiteralSearch))
        #expect(result.movies.map(\.id) == [1])
    }

}
