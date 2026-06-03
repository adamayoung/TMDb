//
//  NaturalLanguageSearchIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Deterministic integration coverage for natural-language search.
///
/// These tests bypass the (non-deterministic, device-gated) on-device model and
/// drive the deterministic ``SearchPlanExecutor`` over the live TMDb API using
/// fixed ``SearchPlan`` inputs. This validates the live data-source bridge —
/// real genre resolution, discover, credits, similar, and curated lists — with
/// stable, tolerant assertions on known values.
///
@Suite(
    .integrationGate,
    .serialized,
    .tags(.naturalLanguageSearch),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct NaturalLanguageSearchIntegrationTests {

    let executor: SearchPlanExecutor

    init() {
        let client = CredentialHelper.shared.makeClient()
        let dataSource = LiveNaturalLanguageSearchDataSource(
            discover: client.discover,
            search: client.search,
            genres: client.genres,
            movies: client.movies,
            tvSeries: client.tvSeries,
            trending: client.trending
        )
        self.executor = SearchPlanExecutor(dataSource: dataSource)
    }

    private func year(of date: Date) -> Int {
        Calendar(identifier: .gregorian).component(.year, from: date)
    }

    @Test("find returns the matching movie for a bare title query")
    func findBareTitle() async throws {
        let plan = SearchPlan(intent: .find, title: "Fight Club")

        let result = try await executor.execute(plan)

        #expect(result.movies.contains { $0.title.localizedCaseInsensitiveContains("Fight Club") })
    }

    @Test("find returns a matching person for a bare name query")
    func findBareName() async throws {
        let plan = SearchPlan(intent: .find, mediaType: .person, title: "Tom Hanks")

        let result = try await executor.execute(plan)

        #expect(result.people.contains { $0.name.localizedCaseInsensitiveContains("Tom Hanks") })
    }

    @Test("browse resolves a genre and decade against the live API")
    func browseGenreAndDecade() async throws {
        let plan = SearchPlan(
            intent: .browse,
            mediaType: .movie,
            genres: ["Science Fiction"],
            date: .decade(1990)
        )

        let result = try await executor.execute(plan)

        #expect(!result.movies.isEmpty)
        // The genre name resolved (no degradation recorded for it).
        #expect(!result.degradations.contains(.unresolvedGenre("Science Fiction")))
        // Server-side primary-release-year filter keeps results within the decade.
        for movie in result.movies {
            if let releaseDate = movie.releaseDate {
                #expect((1990 ... 1999).contains(year(of: releaseDate)))
            }
        }
    }

    @Test("castOf returns the cast of a known film")
    func castOfKnownFilm() async throws {
        let plan = SearchPlan(intent: .castOf, mediaType: .movie, title: "The Matrix")

        let result = try await executor.execute(plan)

        #expect(!result.people.isEmpty)
        #expect(result.people.contains { $0.name.localizedCaseInsensitiveContains("Keanu Reeves") })
    }

    @Test("crewRole returns the director of a known film")
    func crewRoleDirector() async throws {
        let plan = SearchPlan(
            intent: .crewRole,
            mediaType: .movie,
            title: "Jurassic Park",
            crewRole: "Director"
        )

        let result = try await executor.execute(plan)

        #expect(result.people.contains { $0.name.localizedCaseInsensitiveContains("Spielberg") })
    }

    @Test("byPerson returns films featuring a known actor")
    func byPersonKnownActor() async throws {
        let plan = SearchPlan(intent: .byPerson, mediaType: .movie, people: ["Tom Hanks"])

        let result = try await executor.execute(plan)

        #expect(!result.movies.isEmpty)
        #expect(!result.degradations.contains(.unresolvedPerson("Tom Hanks")))
    }

    @Test("similar applies a year window to live recommendations")
    func similarWithYearWindow() async throws {
        let plan = SearchPlan(
            intent: .similar,
            mediaType: .movie,
            title: "The Matrix",
            date: .decade(1990)
        )

        let result = try await executor.execute(plan)

        // Whatever the live recommendations are, the Swift year filter must hold.
        for movie in result.movies {
            let releaseDate = try #require(movie.releaseDate)
            #expect((1990 ... 1999).contains(year(of: releaseDate)))
        }
    }

    @Test("a curated popular-movies list returns results")
    func curatedPopularList() async throws {
        let plan = SearchPlan(intent: .list, mediaType: .movie, list: .popular)

        let result = try await executor.execute(plan)

        #expect(!result.movies.isEmpty)
        #expect(result.movies.count <= 20)
    }

    @Test("a curated trending-people list returns results")
    func curatedTrendingPeople() async throws {
        let plan = SearchPlan(intent: .list, mediaType: .person, list: .trending)

        let result = try await executor.execute(plan)

        #expect(!result.people.isEmpty)
    }

    @Test("an unknown genre is reported but still returns popular results")
    func unknownGenreDegrades() async throws {
        let plan = SearchPlan(
            intent: .browse,
            mediaType: .movie,
            genres: ["Definitely Not A Real Genre"],
            minRating: 7
        )

        let result = try await executor.execute(plan)

        #expect(result.degradations.contains(.unresolvedGenre("Definitely Not A Real Genre")))
        // minRating keeps the query from being underspecified, so the discover
        // call should still return results despite the unresolved genre.
        #expect(!result.movies.isEmpty)
    }

}
