//
//  NaturalLanguagePlannerMocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

final class MockPersonNameExtractor: PersonNameExtracting, @unchecked Sendable {
    var result: [String] = []
    func people(in prompt: String) -> [String] {
        result
    }
}

final class MockPromptLanguageDetector: PromptLanguageDetecting, @unchecked Sendable {
    var isNonEnglish = false
    private(set) var calls: [String] = []
    func isConfidentlyNonEnglish(_ prompt: String) -> Bool {
        calls.append(prompt)
        return isNonEnglish
    }
}

final class MockIntentClassifier: IntentClassifying, @unchecked Sendable {
    var intent: SearchPlan.Intent?
    func classify(_ prompt: String) -> SearchPlan.Intent? {
        intent
    }
}

final class MockDeterministicSearchPlanning: DeterministicSearchPlanning, @unchecked Sendable {
    var plan: SearchPlan?
    private(set) var calls: [String] = []
    func confidentPlan(for prompt: String) -> SearchPlan? {
        calls.append(prompt)
        return plan
    }
}
