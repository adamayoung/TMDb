//
//  GatedSearchPlanGenerator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The default planner: deterministic first, language model only as an
/// evidence-gated fallback.
///
/// When the deterministic planner is confident, its plan is used. Otherwise, if
/// a fallback (Foundation Models) is available, it is consulted and its output
/// is grounded against the prompt. Failing both, the prompt is run as a plain
/// `find`. Availability is `.available` whenever this planner exists (the
/// NaturalLanguage layer is always present on Apple platforms) — the fallback's
/// availability is only an internal gate condition, never surfaced.
///
struct GatedSearchPlanGenerator: SearchPlanGenerating {

    private let deterministic: any DeterministicSearchPlanning
    private let fallback: (any SearchPlanGenerating)?

    init(deterministic: some DeterministicSearchPlanning, fallback: (any SearchPlanGenerating)? = nil) {
        self.deterministic = deterministic
        self.fallback = fallback
    }

    var availability: NaturalLanguageSearchAvailability {
        .available
    }

    func plan(for prompt: String) async throws -> SearchPlan {
        if let confident = deterministic.confidentPlan(for: prompt) {
            return confident
        }

        if let fallback, fallback.availability == .available {
            let raw = try await fallback.plan(for: prompt)
            return PromptGrounder.ground(raw, prompt: prompt)
        }

        // No confident plan and no fallback: run the prompt as a plain search.
        return SearchPlan(intent: .find, title: prompt.trimmingCharacters(in: .whitespacesAndNewlines))
    }

}
