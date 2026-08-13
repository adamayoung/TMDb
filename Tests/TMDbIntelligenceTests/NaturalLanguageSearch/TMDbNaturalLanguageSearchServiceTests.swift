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

    /// 19. regression guard: cancellation still wins over `.searchFailed`
    @Test("cancellation during plan execution surfaces as cancelled")
    func cancellationDuringExecutionSurfacesAsCancelled() async throws {
        // Planning succeeds; the cancellation happens in `executor.execute(plan)`,
        // which reaches the service through an untyped `throws` as a
        // `TMDbError.cancelled`.
        //
        // This pins the CATCH-ARM ORDER: `catch TMDbError.cancelled` must stay
        // above `catch let error as TMDbError`, because the latter matches every
        // TMDbError including `.cancelled`. Reversed, a cancelled search reports
        // as `.searchFailed(.cancelled)` — a withdrawn search reported as a
        // failed one, re-breaking #419.
        planner.planResult = SearchPlan(intent: .list, mediaType: .movie, list: .popular)
        dataSource.curatedMoviesError = TMDbError.cancelled

        await #expect(throws: NaturalLanguageSearchError.cancelled) {
            try await makeService().search(matching: "popular movies")
        }

        // And it is still not rescued by the fallback at this stage either.
        #expect(dataSource.searchAllQueries.isEmpty)
    }

    /// 18. a TMDb failure during plan execution surfaces as `.searchFailed`
    @Test("a TMDb failure during plan execution surfaces as searchFailed")
    func tmdbFailureDuringExecutionSurfacesAsSearchFailed() async throws {
        // The bug: a TMDb 429 during execution was reported as `.planningFailed`,
        // whose description claims the prompt could not be interpreted — so a
        // consumer branching on rate limiting missed TMDb's real 429 entirely.
        planner.planResult = SearchPlan(intent: .list, mediaType: .movie, list: .popular)
        dataSource.curatedMoviesError = TMDbError.tooManyRequests()

        await #expect(throws: NaturalLanguageSearchError.searchFailed(.tooManyRequests())) {
            try await makeService().search(matching: "popular movies")
        }

        // No fallback is attempted after an execution failure. Note this does NOT
        // exercise `canFallBack`, which is only consulted for errors thrown by
        // `planner.plan(for:)` — see `searchFailedPlanIsNotRescuedByFallback`.
        #expect(dataSource.searchAllQueries.isEmpty)
    }

    /// 22. a `.searchFailed` is never rescued by the literal-search fallback
    @Test("a searchFailed plan is never rescued by the literal-search fallback")
    func searchFailedPlanIsNotRescuedByFallback() async throws {
        // Raised from the PLANNING stage, so `canFallBack(from:)` really is
        // consulted. Were its `.searchFailed` arm to return true, the fallback
        // would run and this would return results instead of throwing — retrying
        // against the API that just failed.
        planner.planError = .searchFailed(.tooManyRequests())

        await #expect(throws: NaturalLanguageSearchError.searchFailed(.tooManyRequests())) {
            try await makeService().search(matching: "Kill Bill")
        }

        #expect(dataSource.searchAllQueries.isEmpty)
    }

    /// 20. a TMDb failure in the literal fallback surfaces as `.searchFailed`
    @Test("a TMDb failure in the literal fallback surfaces as searchFailed")
    func tmdbFailureInLiteralFallbackSurfacesAsSearchFailed() async throws {
        planner.planError = .guardrailViolation("rephrase")
        dataSource.searchAllError = TMDbError.tooManyRequests()

        await #expect(throws: NaturalLanguageSearchError.searchFailed(.tooManyRequests())) {
            try await makeService().search(matching: "Kill Bill")
        }

        // The fallback was attempted, then failed — the TMDb error wins over the
        // guardrail violation that triggered it.
        #expect(dataSource.searchAllQueries == ["Kill Bill"])
    }

    /// 21. cancellation in the literal fallback surfaces as cancelled
    @Test("cancellation in the literal fallback surfaces as cancelled")
    func cancellationInLiteralFallbackSurfacesAsCancelled() async throws {
        planner.planError = .guardrailViolation("rephrase")
        dataSource.searchAllError = TMDbError.cancelled

        await #expect(throws: NaturalLanguageSearchError.cancelled) {
            try await makeService().search(matching: "Kill Bill")
        }
    }

    /// 23. an unrecognised error still surfaces as a planning failure
    @Test("an error that is neither a TMDbError nor an NLS error still surfaces as planningFailed")
    func unrecognisedErrorStillSurfacesAsPlanningFailed() async throws {
        struct Unrecognised: Error {}

        planner.planUntypedError = Unrecognised()

        await #expect(throws: NaturalLanguageSearchError.planningFailed(underlying: nil)) {
            try await makeService().search(matching: "x")
        }

        // An untyped planning error bypasses the fallback: the inner catch only
        // matches `NaturalLanguageSearchError`, so it never reaches `canFallBack`
        // — even though a *typed* `.planningFailed` from the planner is eligible.
        #expect(dataSource.searchAllQueries.isEmpty)
    }

}
