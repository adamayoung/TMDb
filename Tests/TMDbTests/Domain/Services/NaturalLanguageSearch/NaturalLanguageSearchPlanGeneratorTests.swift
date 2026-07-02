//
//  NaturalLanguageSearchPlanGeneratorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("NaturalLanguageSearchPlanGenerator")
struct NaturalLanguageSearchPlanGeneratorTests {

    private let people = MockPersonNameExtractor()
    private let language = MockPromptLanguageDetector()

    private func make() -> NaturalLanguageSearchPlanGenerator {
        NaturalLanguageSearchPlanGenerator(
            classifier: RuleBasedIntentClassifier(),
            personExtractor: people,
            languageDetector: language
        )
    }

    @Test("find carries the prompt as title and no people")
    func find() {
        let plan = make().confidentPlan(for: "Fight Club")
        #expect(plan?.intent == .find)
        #expect(plan?.title == "Fight Club")
        #expect(plan?.people.isEmpty == true)
        #expect(plan?.isInScope == true)
    }

    @Test("abstains on a confidently non-English prompt")
    func nonEnglishPromptAbstains() {
        language.isNonEnglish = true
        // Without the language gate this would classify as a literal `find`.
        let plan = make().confidentPlan(for: "un bon film avec de grands acteurs")
        #expect(plan == nil)
        #expect(language.calls == ["un bon film avec de grands acteurs"])
    }

    @Test("does not abstain when the prompt is English")
    func englishPromptDoesNotAbstain() {
        language.isNonEnglish = false
        #expect(make().confidentPlan(for: "trending shows")?.intent == .list)
    }

    @Test("list extracts kind and media type")
    func list() {
        let plan = make().confidentPlan(for: "trending shows")
        #expect(plan?.intent == .list)
        #expect(plan?.list == .trending)
        #expect(plan?.mediaType == .tv)
    }

    @Test("an airing-today list resolves to the tv media type")
    func airingTodayIsTV() {
        let plan = make().confidentPlan(for: "what's airing today")
        #expect(plan?.intent == .list)
        #expect(plan?.list == .airingToday)
        #expect(plan?.mediaType == .tv)
    }

    @Test("castOf extracts the title")
    func castOf() {
        let plan = make().confidentPlan(for: "cast of The Matrix")
        #expect(plan?.intent == .castOf)
        #expect(plan?.title == "The Matrix")
    }

    @Test("crewRole extracts title and job")
    func crewRole() {
        let plan = make().confidentPlan(for: "who directed Jurassic Park")
        #expect(plan?.intent == .crewRole)
        #expect(plan?.title == "Jurassic Park")
        #expect(plan?.crewRole == "Director")
    }

    @Test("similar extracts the title and has no people")
    func similar() {
        let plan = make().confidentPlan(for: "movies like Inception")
        #expect(plan?.intent == .similar)
        #expect(plan?.title == "Inception")
        #expect(plan?.people.isEmpty == true)
    }

    @Test("byPerson uses the extracted people, with empty title")
    func byPerson() {
        people.result = ["Tom Hanks"]
        let plan = make().confidentPlan(for: "movies with Tom Hanks")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.people == ["Tom Hanks"])
        #expect(plan?.title == nil)
    }

    @Test("byPerson recovers the name structurally from a lead when NER misses it")
    func byPersonStructuralFromLead() {
        people.result = [] // NER finds nothing
        let plan = make().confidentPlan(for: "movies with denzel")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.people == ["denzel"])
    }

    @Test("byPerson abstains when no person can be recovered at all")
    func byPersonNoPersonAbstains() {
        people.result = []
        // A filmography question has no lead/suffix to recover a name structurally,
        // so when NER finds nothing the planner abstains (defers to the fallback).
        #expect(make().confidentPlan(for: "what has it been in") == nil)
    }

    @Test("an intent whose mandatory slot is missing abstains")
    func missingSlotAbstains() {
        #expect(make().confidentPlan(for: "who directed") == nil) // crewRole, no title
        #expect(make().confidentPlan(for: "cast of") == nil) // castOf, no title
    }

    @Test("discover/mood prompts abstain")
    func discoverAbstains() {
        #expect(make().confidentPlan(for: "90s sci-fi") == nil)
        #expect(make().confidentPlan(for: "feel-good movies") == nil)
    }

    @Test("byPerson captures date and runtime slots")
    func byPersonSlots() {
        people.result = ["Tom Hanks"]
        let plan = make().confidentPlan(for: "Tom Hanks movies from the 90s")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.date == .decade(1990))
    }

    @Test("byPerson captures a trailing rating cue as a minimum rating")
    func byPersonRatingSlot() {
        people.result = ["Tom Hanks"]
        let plan = make().confidentPlan(for: "movies with Tom Hanks that are critically acclaimed")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.minRating == 7.0)
    }

    @Test("crewRole strips a multi-word lead so only the title remains")
    func crewRoleMultiWordLead() {
        let plan = make().confidentPlan(for: "who composed the music for Dune")
        #expect(plan?.intent == .crewRole)
        #expect(plan?.title == "Dune")
        #expect(plan?.crewRole == "Original Music Composer")
    }

    @Test("a title-bearing TV prompt resolves to the tv media type")
    func titleMediaTypeTV() {
        let tv = make().confidentPlan(for: "shows like Breaking Bad")
        #expect(tv?.intent == .similar)
        #expect(tv?.title == "Breaking Bad")
        #expect(tv?.mediaType == .tv)

        let movie = make().confidentPlan(for: "movies like Inception")
        #expect(movie?.mediaType == nil)
    }

    @Test("who starred in is a cast query, not a plain find")
    func whoStarredInIsCast() {
        let plan = make().confidentPlan(for: "who starred in Gladiator")
        #expect(plan?.intent == .castOf)
        #expect(plan?.title == "Gladiator")
    }

    @Test("a filmography question is byPerson")
    func filmographyQuestion() {
        people.result = ["Ryan Gosling"]
        let plan = make().confidentPlan(for: "what has Ryan Gosling been in")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.people == ["Ryan Gosling"])
    }

    @Test("a tv-shows suffix is byPerson with the tv media type")
    func tvShowsSuffixIsByPerson() {
        people.result = ["Bryan Cranston"]
        let plan = make().confidentPlan(for: "Bryan Cranston tv shows")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.mediaType == .tv)
        #expect(plan?.people == ["Bryan Cranston"])
    }

    @Test("a directed-by lead sets a Director crew role on the byPerson plan")
    func directedBySetsCrewRole() {
        people.result = ["Christopher Nolan"]
        let plan = make().confidentPlan(for: "films directed by Christopher Nolan")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.crewRole == "Director")
    }

    @Test("byPerson recovers the name structurally when NER misses it")
    func byPersonStructuralFallback() {
        people.result = [] // NER finds nothing
        let plan = make().confidentPlan(for: "Scarlett Johansson films")
        #expect(plan?.intent == .byPerson)
        #expect(plan?.people == ["Scarlett Johansson"])
    }
}

@Suite("GatedSearchPlanGenerator")
struct GatedSearchPlanGeneratorTests {

    @Test("availability is always available")
    func availabilityAvailable() {
        let gate = GatedSearchPlanGenerator(deterministic: MockDeterministicSearchPlanning(), fallback: nil)
        #expect(gate.availability == .available)
    }

    @Test("a confident plan is returned and the fallback is not called")
    func confidentWins() async throws {
        let det = MockDeterministicSearchPlanning()
        det.plan = SearchPlan(intent: .castOf, title: "Dune")
        let fallback = MockSearchPlanGenerator()
        let gate = GatedSearchPlanGenerator(deterministic: det, fallback: fallback)

        let plan = try await gate.plan(for: "cast of Dune")

        #expect(plan.intent == .castOf)
        #expect(fallback.planCalls.isEmpty)
    }

    @Test("abstain routes to an available fallback, grounded")
    func abstainUsesFallback() async throws {
        let det = MockDeterministicSearchPlanning() // plan == nil → abstain
        let fallback = MockSearchPlanGenerator()
        fallback.planResult = SearchPlan(intent: .byPerson, people: ["Invented Person"])
        let gate = GatedSearchPlanGenerator(deterministic: det, fallback: fallback)

        let plan = try await gate.plan(for: "feel-good movies")

        #expect(fallback.planCalls == ["feel-good movies"])
        #expect(plan.people.isEmpty) // grounded: "Invented Person" not in the prompt
    }

    @Test("abstain with no fallback runs a plain find on the prompt")
    func abstainNoFallback() async throws {
        let gate = GatedSearchPlanGenerator(deterministic: MockDeterministicSearchPlanning(), fallback: nil)
        let plan = try await gate.plan(for: "feel-good movies")
        #expect(plan.intent == .find)
        #expect(plan.title == "feel-good movies")
    }

    @Test("abstain with an unavailable fallback runs a plain find")
    func abstainUnavailableFallback() async throws {
        let fallback = MockSearchPlanGenerator()
        fallback.availability = .unavailable(.deviceNotEligible)
        let gate = GatedSearchPlanGenerator(deterministic: MockDeterministicSearchPlanning(), fallback: fallback)

        let plan = try await gate.plan(for: "feel-good movies")

        #expect(plan.intent == .find)
        #expect(fallback.planCalls.isEmpty)
    }
}

@Suite("PromptGrounder")
struct PromptGrounderTests {

    @Test("drops people not present in the prompt, keeps those present")
    func filtersPeople() {
        let raw = SearchPlan(intent: .byPerson, people: ["Tom Hanks", "Invented Person"])
        let grounded = PromptGrounder.ground(raw, prompt: "movies with Tom Hanks")
        #expect(grounded.people == ["Tom Hanks"])
    }

    @Test("forces isInScope true and keeps gazetteer genres")
    func forcesScopeKeepsGenres() {
        let raw = SearchPlan(intent: .browse, isInScope: false, genres: ["Science Fiction"])
        let grounded = PromptGrounder.ground(raw, prompt: "sci-fi from the 90s")
        #expect(grounded.isInScope == true)
        #expect(grounded.genres == ["Science Fiction"]) // kept though not a substring
    }

    @Test("drops an invented title")
    func dropsInventedTitle() {
        let raw = SearchPlan(intent: .find, title: "A Movie The User Never Typed")
        let grounded = PromptGrounder.ground(raw, prompt: "something funny")
        #expect(grounded.title == nil)
    }
}
