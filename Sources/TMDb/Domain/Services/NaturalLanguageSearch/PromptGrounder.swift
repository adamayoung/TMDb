//
//  PromptGrounder.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Re-grounds a language-model-produced ``SearchPlan`` against the prompt so the
/// model cannot inject entities the user never wrote.
///
/// Runs ONLY on fallback (model) output, never on the deterministic planner's
/// output. String operands the user could only have named literally (title,
/// people, companies, exclusions) are dropped unless they appear in the prompt.
/// Gazetteer-derived fields (genres, crew role) and numeric slots are left as-is
/// — a canonical "Science Fiction" need not be a substring of "sci-fi".
///
enum PromptGrounder {

    static func ground(_ plan: SearchPlan, prompt: String) -> SearchPlan {
        let haystack = prompt.lowercased()
        func present(_ value: String) -> Bool {
            let trimmed = value.trimmingCharacters(in: .whitespaces).lowercased()
            return !trimmed.isEmpty && haystack.contains(trimmed)
        }

        return SearchPlan(
            intent: plan.intent,
            isInScope: true, // the fallback is only consulted for in-scope prompts
            mediaType: plan.mediaType,
            title: plan.title.flatMap { present($0) ? $0 : nil },
            people: plan.people.filter(present),
            crewRole: plan.crewRole,
            genres: plan.genres,
            excludeTitles: plan.excludeTitles.filter(present),
            companies: plan.companies.filter(present),
            moodTerm: plan.moodTerm,
            date: plan.date,
            runtimeMaxMinutes: plan.runtimeMaxMinutes,
            minRating: plan.minRating,
            list: plan.list
        )
    }

}
