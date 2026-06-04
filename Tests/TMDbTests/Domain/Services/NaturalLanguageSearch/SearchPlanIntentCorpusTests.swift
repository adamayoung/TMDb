//
//  SearchPlanIntentCorpusTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("Intent classifier corpus")
struct SearchPlanIntentCorpusTests {

    private struct Case { let prompt: String; let expected: SearchPlan.Intent? }
    private func c(_ prompt: String, _ expected: SearchPlan.Intent?) -> Case {
        .init(prompt: prompt, expected: expected)
    }

    private var corpus: [Case] {
        [
            // find — bare titles and names
            c("Fight Club", .find), c("The Matrix", .find), c("Inception", .find),
            c("Breaking Bad", .find), c("Stranger Things", .find), c("The Godfather", .find),
            c("Pulp Fiction", .find), c("Dune", .find), c("Oppenheimer", .find),
            c("Interstellar", .find), c("Titanic", .find), c("The Dark Knight", .find),
            c("Tom Hanks", .find), c("Brad Pitt", .find), c("Meryl Streep", .find),
            c("Cast Away", .find), c("Like Crazy", .find), c("Gladiator", .find),
            // out-of-scope deterministically degrades to plain search (find) in v1
            c("a good book about space", .find), c("best pizza recipe", .find),
            c("weather tomorrow", .find),

            // byPerson
            c("movies with Tom Hanks", .byPerson), c("Brad Pitt movies", .byPerson),
            c("films directed by Christopher Nolan", .byPerson),
            c("movies starring Meryl Streep", .byPerson), c("Scarlett Johansson films", .byPerson),
            c("Quentin Tarantino movies", .byPerson), c("movies featuring Denzel Washington", .byPerson),
            c("films with Leonardo DiCaprio", .byPerson), c("Keanu Reeves movies", .byPerson),
            c("movies by Steven Spielberg", .byPerson), c("Tom Hanks movies from the 90s", .byPerson),
            c("directed by Greta Gerwig", .byPerson),

            // castOf
            c("cast of Fight Club", .castOf), c("people in The Matrix", .castOf),
            c("who's in Inception", .castOf), c("actors in Dune", .castOf),
            c("the cast of Stranger Things", .castOf), c("stars of Titanic", .castOf),
            c("main cast of Breaking Bad", .castOf), c("who appears in Pulp Fiction", .castOf),
            c("cast list for Jurassic Park", .castOf), c("lead actors in The Dark Knight", .castOf),

            // crewRole
            c("who directed Jurassic Park", .crewRole), c("director of The Godfather", .crewRole),
            c("who wrote Pulp Fiction", .crewRole), c("composer of Interstellar", .crewRole),
            c("who directed Titanic", .crewRole), c("cinematographer of Blade Runner", .crewRole),
            c("producer of Inception", .crewRole), c("who composed the music for Dune", .crewRole),

            // similar
            c("movies like Inception", .similar), c("shows similar to Breaking Bad", .similar),
            c("films like The Matrix", .similar), c("something like Stranger Things", .similar),
            c("movies similar to Fight Club", .similar), c("tv shows like Game of Thrones", .similar),
            c("in the vein of Blade Runner", .similar), c("recommendations based on The Office", .similar),
            c("shows like The Crown", .similar), c("movies like Get Out", .similar),

            // list
            c("trending movies", .list), c("popular shows", .list), c("top rated movies", .list),
            c("new releases", .list), c("upcoming movies", .list), c("what's airing today", .list),
            c("now playing in theaters", .list), c("most popular tv series", .list),
            c("trending people", .list), c("popular actors", .list),

            // abstain — browse / mood deferred to the fallback
            c("90s sci-fi", nil), c("horror films from the 80s", nil),
            c("French romantic comedies", nil), c("highly rated documentaries", nil),
            c("Korean horror movies", nil), c("feel-good movies", nil), c("something scary", nil),
            c("cozy films for a rainy day", nil), c("a tearjerker", nil), c("comfort movies", nil),
            c("movies from the 1980s", nil), c("action movies from 2019", nil),
            c("westerns from the 1960s", nil), c("romantic comedies", nil)
        ]
    }

    @Test("classifier matches the labelled corpus")
    func corpusAccuracy() {
        let classifier = RuleBasedIntentClassifier()
        var misses: [String] = []
        for testCase in corpus {
            let got = classifier.classify(testCase.prompt)
            if got != testCase.expected {
                misses.append("\"\(testCase.prompt)\" want \(String(describing: testCase.expected)) "
                    + "got \(String(describing: got))")
            }
        }
        let accuracy = Int(Double(corpus.count - misses.count) / Double(corpus.count) * 100)
        let report = misses.joined(separator: "\n")
        #expect(misses.isEmpty, "Intent corpus \(misses.count)/\(corpus.count) misses (\(accuracy)%):\n\(report)")
    }
}
