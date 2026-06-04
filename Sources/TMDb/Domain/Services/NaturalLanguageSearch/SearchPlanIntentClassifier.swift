//
//  SearchPlanIntentClassifier.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Decides the ``SearchPlan/Intent`` for a prompt, or `nil` to abstain.
///
/// This is the seam where a future Core ML text classifier can replace the
/// rule-based implementation without changing the rest of the planner.
///
protocol IntentClassifying: Sendable {

    ///
    /// Classifies a prompt's intent.
    ///
    /// - Parameter prompt: The natural-language prompt.
    ///
    /// - Returns: The intent, or `nil` to abstain (let the fallback decide).
    ///
    func classify(_ prompt: String) -> SearchPlan.Intent?

}

///
/// A deterministic, rule-based ``IntentClassifying`` for the v1 intent set:
/// `find`, `byPerson`, `castOf`, `crewRole`, `similar`, `list`.
///
/// It detects each high-precision intent "family" from lexical cues. Exactly one
/// family → that intent; more than one (mixed intent) → abstain; none → `find`
/// for a bare query, or abstain when discover/mood cues are present (those
/// intents are deferred to the language-model fallback).
///
struct RuleBasedIntentClassifier: IntentClassifying {

    func classify(_ prompt: String) -> SearchPlan.Intent? {
        let text = SearchPlanLexicon.normalize(prompt)
        guard !text.isEmpty else {
            return nil
        }

        var families: [SearchPlan.Intent] = []
        // A list cue alongside a genre ("highly rated documentaries") is a browse
        // query, not a curated list — defer it. Pure list cues fire `.list`.
        if SearchPlanLexicon.listKind(in: text) != nil, !SearchPlanLexicon.hasGenre(text) {
            families.append(.list)
        }
        if SearchPlanLexicon.isSimilar(text) { families.append(.similar) }
        if SearchPlanLexicon.isCastOf(text) { families.append(.castOf) }
        if SearchPlanLexicon.crewRoleJob(in: text) != nil { families.append(.crewRole) }
        if SearchPlanLexicon.isByPerson(text) { families.append(.byPerson) }

        if families.count == 1 {
            return families[0]
        }
        if families.count > 1 {
            // Mixed intent ("cast of movies like X") — abstain rather than guess.
            return nil
        }

        // No high-precision intent. A bare title/name is `find`; anything with
        // discover/mood cues (genre, decade, runtime, rating, mood) is deferred.
        return SearchPlanLexicon.hasDiscoverCue(text) ? nil : .find
    }

}
