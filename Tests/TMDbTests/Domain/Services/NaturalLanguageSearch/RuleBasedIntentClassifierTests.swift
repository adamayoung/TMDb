//
//  RuleBasedIntentClassifierTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("RuleBasedIntentClassifier")
struct RuleBasedIntentClassifierTests {

    private let classifier = RuleBasedIntentClassifier()

    @Test("list cues classify as list", arguments: [
        "trending movies", "popular shows", "what's in cinemas", "new releases",
        "upcoming movies", "what's airing today", "top rated movies", "popular actors"
    ])
    func listCues(_ prompt: String) {
        #expect(classifier.classify(prompt) == .list)
    }

    @Test("similar cues classify as similar", arguments: [
        "movies like Inception", "shows similar to Breaking Bad",
        "films in the vein of Blade Runner", "something like Stranger Things"
    ])
    func similarCues(_ prompt: String) {
        #expect(classifier.classify(prompt) == .similar)
    }

    @Test("cast cues classify as castOf", arguments: [
        "cast of The Matrix", "who's in Inception", "actors in Dune",
        "stars of Titanic", "main cast of Breaking Bad"
    ])
    func castCues(_ prompt: String) {
        #expect(classifier.classify(prompt) == .castOf)
    }

    @Test("crew-role cues classify as crewRole", arguments: [
        "who directed Jurassic Park", "composer of Interstellar",
        "who wrote Pulp Fiction", "cinematographer of Blade Runner"
    ])
    func crewRoleCues(_ prompt: String) {
        #expect(classifier.classify(prompt) == .crewRole)
    }

    @Test("person cues classify as byPerson", arguments: [
        "movies with Tom Hanks", "Brad Pitt movies", "films directed by Nolan",
        "movies starring Meryl Streep", "Scarlett Johansson films", "featuring Denzel Washington"
    ])
    func byPersonCues(_ prompt: String) {
        #expect(classifier.classify(prompt) == .byPerson)
    }

    @Test("bare titles and names classify as find", arguments: [
        "Fight Club", "The Dark Knight", "Tom Hanks", "Breaking Bad", "Inception"
    ])
    func bareQueriesAreFind(_ prompt: String) {
        #expect(classifier.classify(prompt) == .find)
    }

    @Test("discover/mood prompts abstain (deferred to fallback)", arguments: [
        "90s sci-fi", "feel-good movies", "highly rated documentaries",
        "horror movies", "French romantic comedies", "cozy films", "movies from the 1980s"
    ])
    func discoverCuesAbstain(_ prompt: String) {
        #expect(classifier.classify(prompt) == nil)
    }

    @Test("mixed-intent prompts abstain", arguments: [
        "cast of movies like Inception", "who directed films like Heat"
    ])
    func mixedIntentAbstains(_ prompt: String) {
        #expect(classifier.classify(prompt) == nil)
    }

    @Test("a keyword inside a title does not trigger that intent", arguments: [
        "Cast Away", "Like Crazy", "The Avengers"
    ])
    func keywordInTitleIsFind(_ prompt: String) {
        #expect(classifier.classify(prompt) == .find)
    }

    @Test("empty or whitespace prompts abstain", arguments: ["", "   ", "  \n "])
    func emptyAbstains(_ prompt: String) {
        #expect(classifier.classify(prompt) == nil)
    }

}
