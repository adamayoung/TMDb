//
//  TMDbNaturalLanguageSearchService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The default ``NaturalLanguageSearchService`` implementation.
///
/// It composes a plan generator (the on-device model) with a deterministic
/// executor. When the model rejects a prompt — for example via a guardrail
/// violation — it falls back to a literal text search so legitimate queries are
/// not dead-ended.
///
final class TMDbNaturalLanguageSearchService: NaturalLanguageSearchService {

    private let planner: any SearchPlanGenerating
    private let executor: SearchPlanExecutor
    private let dataSource: any NaturalLanguageSearchDataSource
    private let literalFallbackEnabled: Bool
    private let resultLimit: Int

    init(
        planner: some SearchPlanGenerating,
        executor: SearchPlanExecutor,
        dataSource: some NaturalLanguageSearchDataSource,
        literalFallbackEnabled: Bool = true,
        resultLimit: Int = 20
    ) {
        self.planner = planner
        self.executor = executor
        self.dataSource = dataSource
        self.literalFallbackEnabled = literalFallbackEnabled
        self.resultLimit = resultLimit
    }

    var availability: NaturalLanguageSearchAvailability {
        planner.availability
    }

    func plan(for prompt: String) async throws -> SearchPlan {
        try ensureAvailable()
        return try await planner.plan(for: prompt)
    }

    func search(matching prompt: String) async throws -> NaturalLanguageSearchResult {
        try ensureAvailable()

        let plan: SearchPlan
        do {
            plan = try await planner.plan(for: prompt)
        } catch let error as NaturalLanguageSearchError where canFallBack(from: error) {
            return try await literalSearch(for: prompt, after: error)
        }

        return try await executor.execute(plan)
    }

}

extension TMDbNaturalLanguageSearchService {

    private func ensureAvailable() throws {
        if case .unavailable(let reason) = planner.availability {
            throw NaturalLanguageSearchError.modelUnavailable(reason)
        }
    }

    private func canFallBack(from error: NaturalLanguageSearchError) -> Bool {
        guard literalFallbackEnabled else {
            return false
        }
        switch error {
        case .guardrailViolation, .refused, .planningFailed:
            return true
        case .modelUnavailable, .outOfScope, .unsupportedLanguage, .rateLimited:
            return false
        }
    }

    private func literalSearch(
        for prompt: String,
        after error: NaturalLanguageSearchError
    ) async throws -> NaturalLanguageSearchResult {
        let found = try await dataSource.searchAll(query: prompt)

        var degradations: [SearchDegradation] = [.planRejectedUsedLiteralSearch]
        if case .refused(let explanation) = error, let explanation {
            degradations.append(.refusalExplained(explanation))
        }

        return NaturalLanguageSearchResult(
            interpretation: prompt,
            movies: Array(found.movies.prefix(resultLimit)),
            tvSeries: Array(found.tvSeries.prefix(resultLimit)),
            people: Array(found.people.prefix(resultLimit)),
            degradations: degradations
        )
    }

}
