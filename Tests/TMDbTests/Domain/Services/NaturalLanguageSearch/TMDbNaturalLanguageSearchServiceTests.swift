//
//  TMDbNaturalLanguageSearchServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("TMDbNaturalLanguageSearchService")
struct TMDbNaturalLanguageSearchServiceTests {

    let planner: MockSearchPlanGenerator
    let dataSource: MockNaturalLanguageSearchDataSource

    init() {
        self.planner = MockSearchPlanGenerator()
        self.dataSource = MockNaturalLanguageSearchDataSource()
    }

    private func makeService(
        literalFallbackEnabled: Bool = true
    ) -> TMDbNaturalLanguageSearchService {
        TMDbNaturalLanguageSearchService(
            planner: planner,
            executor: SearchPlanExecutor(dataSource: dataSource),
            dataSource: dataSource,
            literalFallbackEnabled: literalFallbackEnabled
        )
    }

    @Test("search plans then executes")
    func searchPlansThenExecutes() async throws {
        planner.planResult = SearchPlan(intent: .list, mediaType: .movie, list: .popular)
        dataSource.curatedMoviesResult = [NLSFixture.movie(id: 7)]

        let result = try await makeService().search(matching: "popular movies")

        #expect(planner.planCalls == ["popular movies"])
        #expect(result.movies.map(\.id) == [7])
    }

    @Test("search throws when the model is unavailable")
    func searchUnavailable() async throws {
        planner.availability = .unavailable(.notEnabled)

        await #expect(throws: NaturalLanguageSearchError.self) {
            try await makeService().search(matching: "anything")
        }
    }

    @Test("guardrail violation falls back to a literal search")
    func guardrailFallback() async throws {
        planner.planError = .guardrailViolation("rephrase")
        dataSource.searchAllResult = ([NLSFixture.movie(id: 1, title: "Kill Bill")], [], [])

        let result = try await makeService().search(matching: "Kill Bill")

        #expect(result.movies.map(\.id) == [1])
        #expect(result.degradations.contains(.planRejectedUsedLiteralSearch))
        #expect(dataSource.searchAllQueries == ["Kill Bill"])
    }

    @Test("refusal fallback includes the explanation")
    func refusalFallbackExplanation() async throws {
        planner.planError = .refused("not allowed")
        dataSource.searchAllResult = ([NLSFixture.movie(id: 1)], [], [])

        let result = try await makeService().search(matching: "edgy prompt")

        #expect(result.degradations.contains(.planRejectedUsedLiteralSearch))
        #expect(result.degradations.contains(.refusalExplained("not allowed")))
    }

    @Test("disabling the fallback rethrows guardrail violations")
    func fallbackDisabledRethrows() async throws {
        planner.planError = .guardrailViolation(nil)

        await #expect(throws: NaturalLanguageSearchError.self) {
            try await makeService(literalFallbackEnabled: false).search(matching: "x")
        }
        #expect(dataSource.searchAllQueries.isEmpty)
    }

    @Test("rate limiting is not rescued by the fallback")
    func rateLimitedNotRescued() async throws {
        planner.planError = .rateLimited

        await #expect(throws: NaturalLanguageSearchError.self) {
            try await makeService().search(matching: "x")
        }
        #expect(dataSource.searchAllQueries.isEmpty)
    }

    @Test("out-of-scope is not rescued by the fallback")
    func outOfScopeNotRescued() async throws {
        planner.planResult = SearchPlan(intent: .browse, isInScope: false)

        await #expect(throws: NaturalLanguageSearchError.self) {
            try await makeService().search(matching: "a good book about space")
        }
        #expect(dataSource.searchAllQueries.isEmpty)
    }

    @Test("plan(for:) throws when unavailable")
    func planForUnavailable() async throws {
        planner.availability = .unavailable(.deviceNotEligible)

        await #expect(throws: NaturalLanguageSearchError.self) {
            try await makeService().plan(for: "x")
        }
    }

}
