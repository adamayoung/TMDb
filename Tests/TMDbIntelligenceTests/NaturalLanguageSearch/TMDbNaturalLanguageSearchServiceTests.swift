//
//  TMDbNaturalLanguageSearchServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb
@testable import TMDbIntelligence

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

    @Test("a cancelled plan surfaces as cancelled, not a planning failure")
    func cancelledPlanSurfacesAsCancelled() async throws {
        planner.planUntypedError = CancellationError()

        await #expect(throws: NaturalLanguageSearchError.cancelled) {
            try await makeService().search(matching: "popular movies")
        }
    }

    @Test("a cancelled plan is never rescued by the literal-search fallback")
    func cancelledPlanIsNotRescuedByFallback() async throws {
        // The regression this exists for: cancellation used to be wrapped as
        // `.planningFailed`, which IS fallback-eligible, so a cancelled search
        // went on to issue three fresh live searches — doing the very work the
        // caller had abandoned.
        planner.planError = .cancelled

        await #expect(throws: NaturalLanguageSearchError.cancelled) {
            try await makeService().search(matching: "Kill Bill")
        }

        #expect(dataSource.searchAllQueries.isEmpty)
    }

    @Test("a cancelled plan(for:) surfaces as cancelled")
    func cancelledPlanForSurfacesAsCancelled() async throws {
        planner.planUntypedError = CancellationError()

        await #expect(throws: NaturalLanguageSearchError.cancelled) {
            try await makeService().plan(for: "x")
        }
    }

    @Test("canFallBack is false for cancellation")
    func canFallBackIsFalseForCancellation() async throws {
        planner.planError = .cancelled

        // Even with the fallback explicitly enabled, cancellation must not use it.
        await #expect(throws: NaturalLanguageSearchError.cancelled) {
            try await makeService(literalFallbackEnabled: true).search(matching: "x")
        }

        #expect(dataSource.searchAllQueries.isEmpty)
    }

}
