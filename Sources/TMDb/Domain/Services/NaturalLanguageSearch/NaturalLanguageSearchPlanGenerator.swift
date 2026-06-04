//
//  NaturalLanguageSearchPlanGenerator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The deterministic planner: rule-based intent classification + span-bounded
/// entity extraction (people via NER, titles via lead-phrase stripping) + slot
/// parsing. Pure and synchronous; dependencies are injected so it is testable on
/// every platform with mocks.
///
/// Honours the executor's contracts: `find`/`similar` emit empty `people`; every
/// plan is in scope; `find` carries the prompt as `title`; an intent whose
/// mandatory slot cannot be extracted abstains (returns `nil`).
///
struct NaturalLanguageSearchPlanGenerator: DeterministicSearchPlanning {

    private let classifier: any IntentClassifying
    private let personExtractor: any PersonNameExtracting

    init(classifier: some IntentClassifying, personExtractor: some PersonNameExtracting) {
        self.classifier = classifier
        self.personExtractor = personExtractor
    }

    func confidentPlan(for prompt: String) -> SearchPlan? {
        let normalized = SearchPlanLexicon.normalize(prompt)
        guard let intent = classifier.classify(prompt) else {
            return nil
        }

        switch intent {
        case .find:
            return findPlan(prompt: prompt)

        case .list:
            return listPlan(normalized: normalized)

        case .castOf:
            return titlePlan(.castOf, prompt: prompt, normalized: normalized, leads: SearchPlanLexicon.castLeads)

        case .crewRole:
            return crewRolePlan(prompt: prompt, normalized: normalized)

        case .similar:
            return titlePlan(
                .similar,
                prompt: prompt,
                normalized: normalized,
                leads: SearchPlanLexicon.similarLeads,
                withDate: true
            )

        case .byPerson:
            return byPersonPlan(prompt: prompt, normalized: normalized)

        case .browse, .mood:
            return nil
        }
    }

    private func findPlan(prompt: String) -> SearchPlan? {
        let title = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else {
            return nil
        }
        return SearchPlan(intent: .find, title: title)
    }

    private func listPlan(normalized: String) -> SearchPlan? {
        guard let kind = SearchPlanLexicon.listKind(in: normalized) else {
            return nil
        }
        return SearchPlan(
            intent: .list,
            mediaType: SearchPlanLexicon.mediaType(in: normalized),
            list: kind
        )
    }

    private func crewRolePlan(prompt: String, normalized: String) -> SearchPlan? {
        guard let role = SearchPlanLexicon.crewRoleJob(in: normalized) else {
            return nil
        }
        return titlePlan(
            .crewRole,
            prompt: prompt,
            normalized: normalized,
            leads: [role.lead],
            crewRole: role.job
        )
    }

    private func byPersonPlan(prompt: String, normalized: String) -> SearchPlan? {
        let people = personExtractor.people(in: prompt)
        guard !people.isEmpty else {
            return nil
        }
        // byPerson runs through the discover path, which honours rating and
        // runtime constraints (unlike the recommendations-based `similar` path),
        // so a prompt like "movies with Tom Hanks that are critically acclaimed"
        // keeps them. Genre is deferred to the fallback by the classifier (a
        // leading genre cue abstains), so it is not extracted here.
        return SearchPlan(
            intent: .byPerson,
            mediaType: titleMediaType(normalized),
            people: people,
            date: RelativeDateParser.parse(normalized),
            runtimeMaxMinutes: RuntimeRatingParser.runtimeMaxMinutes(normalized),
            minRating: RuntimeRatingParser.minRating(normalized)
        )
    }

    private func titlePlan(
        _ intent: SearchPlan.Intent,
        prompt: String,
        normalized: String,
        leads: [String],
        crewRole: String? = nil,
        withDate: Bool = false
    ) -> SearchPlan? {
        let title = TitleExtractor.title(from: prompt, strippingLeads: leads)
        guard !title.isEmpty else {
            return nil
        }
        // Only `date` is wired here: it is the single slot the `similar`
        // (recommendations) path applies. Genre/runtime/rating are not consumed
        // by that path, so they are intentionally omitted rather than set dead.
        return SearchPlan(
            intent: intent,
            mediaType: titleMediaType(normalized),
            title: title,
            crewRole: crewRole,
            date: withDate ? RelativeDateParser.parse(normalized) : nil
        )
    }

    /// Title-bearing intents only distinguish movie vs TV (never person).
    private func titleMediaType(_ normalized: String) -> SearchPlan.MediaType? {
        SearchPlanLexicon.contains(normalized, anyOf: ["show", "shows", "series", "tv", "television"])
            ? .tv : nil
    }

}
