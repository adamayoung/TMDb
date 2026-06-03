//
//  MockSearchPlanGenerator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

final class MockSearchPlanGenerator: SearchPlanGenerating, @unchecked Sendable {

    var availability: NaturalLanguageSearchAvailability = .available
    var planResult = SearchPlan(intent: .list, mediaType: .movie, list: .popular)
    var planError: NaturalLanguageSearchError?

    private(set) var planCalls: [String] = []

    func plan(for prompt: String) async throws -> SearchPlan {
        planCalls.append(prompt)
        if let planError {
            throw planError
        }
        return planResult
    }

}
