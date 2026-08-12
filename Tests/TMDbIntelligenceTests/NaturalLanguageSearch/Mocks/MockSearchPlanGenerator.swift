//
//  MockSearchPlanGenerator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb
@testable import TMDbIntelligence

final class MockSearchPlanGenerator: SearchPlanGenerating, @unchecked Sendable {

    var availability: NaturalLanguageSearchAvailability = .available
    var planResult = SearchPlan(intent: .list, mediaType: .movie, list: .popular)
    var planError: NaturalLanguageSearchError?

    /// An untyped error to throw instead, for exercising the arms that classify
    /// errors the planner did not wrap — a bare `CancellationError`, say.
    var planUntypedError: (any Error)?

    private(set) var planCalls: [String] = []

    func plan(for prompt: String) async throws -> SearchPlan {
        planCalls.append(prompt)
        if let planUntypedError {
            throw planUntypedError
        }
        if let planError {
            throw planError
        }
        return planResult
    }

}
