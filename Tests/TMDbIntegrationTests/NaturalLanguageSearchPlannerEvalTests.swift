//
//  NaturalLanguageSearchPlannerEvalTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels)
    import Foundation
    import Testing
    @testable import TMDb

    private struct EvalCase {
        let prompt: String
        let accept: [SearchPlan.Intent]
        let outOfScope: Bool

        init(_ prompt: String, _ accept: SearchPlan.Intent..., outOfScope: Bool = false) {
            self.prompt = prompt
            self.accept = accept
            self.outOfScope = outOfScope
        }
    }

    @Suite(
        .serialized,
        .tags(.naturalLanguageSearch),
        .enabled(if: ProcessInfo.processInfo.environment["NLS_EVAL"] != nil
            && CredentialHelper.shared.hasAPIKey)
    )
    struct NaturalLanguageSearchPlannerEvalTests {

        // swiftlint:disable:next function_body_length
        private static func corpus() -> [EvalCase] {
            [
                // find — bare titles
                EvalCase("Fight Club", .find),
                EvalCase("The Matrix", .find),
                EvalCase("Inception", .find),
                EvalCase("Breaking Bad", .find),
                EvalCase("Stranger Things", .find),
                EvalCase("The Godfather", .find),
                EvalCase("Pulp Fiction", .find),
                EvalCase("Game of Thrones", .find),
                EvalCase("Dune", .find),
                EvalCase("Oppenheimer", .find),
                EvalCase("The Office", .find),
                EvalCase("Interstellar", .find),
                EvalCase("Titanic", .find),
                EvalCase("The Dark Knight", .find),
                // find — bare names (byPerson also acceptable)
                EvalCase("Tom Hanks", .find, .byPerson),
                EvalCase("Leonardo DiCaprio", .find, .byPerson),
                EvalCase("Meryl Streep", .find, .byPerson),
                EvalCase("Christopher Nolan", .find, .byPerson),
                EvalCase("Brad Pitt", .find, .byPerson),
                EvalCase("Zendaya", .find, .byPerson),

                // castOf — cast / people in a title
                EvalCase("cast of Fight Club", .castOf),
                EvalCase("people in The Matrix", .castOf),
                EvalCase("who's in Inception", .castOf),
                EvalCase("actors in Dune", .castOf),
                EvalCase("the cast of Stranger Things", .castOf),
                EvalCase("who stars in Oppenheimer", .castOf),
                EvalCase("main cast of Breaking Bad", .castOf),
                EvalCase("actors in The Godfather", .castOf),
                EvalCase("who appears in Pulp Fiction", .castOf),
                EvalCase("cast members of Friends", .castOf),
                EvalCase("stars of Titanic", .castOf),
                EvalCase("who acted in Interstellar", .castOf),
                EvalCase("lead actors in The Dark Knight", .castOf),
                EvalCase("who played in Gladiator", .castOf),
                EvalCase("cast of Avatar", .castOf),
                EvalCase("actors from The Office", .castOf),
                EvalCase("who is in Game of Thrones", .castOf),
                EvalCase("the actors in Forrest Gump", .castOf),
                EvalCase("cast list for Jurassic Park", .castOf),
                EvalCase("who's in the movie Heat", .castOf),

                // crewRole — a specific crew role of a title
                EvalCase("director of Jurassic Park", .crewRole),
                EvalCase("who directed Inception", .crewRole),
                EvalCase("director of The Godfather", .crewRole),
                EvalCase("who wrote Pulp Fiction", .crewRole),
                EvalCase("composer of Interstellar", .crewRole),
                EvalCase("who directed Titanic", .crewRole),
                EvalCase("writer of The Social Network", .crewRole),
                EvalCase("who directed Parasite", .crewRole),
                EvalCase("director of Mad Max Fury Road", .crewRole),
                EvalCase("who composed the music for Dune", .crewRole),
                EvalCase("who directed The Dark Knight", .crewRole),
                EvalCase("director of Schindler's List", .crewRole),
                EvalCase("who directed Goodfellas", .crewRole),
                EvalCase("director of Whiplash", .crewRole),

                // byPerson — titles featuring / by a named person
                EvalCase("movies with Tom Hanks", .byPerson),
                EvalCase("films directed by Christopher Nolan", .byPerson),
                EvalCase("Brad Pitt movies", .byPerson),
                EvalCase("movies starring Meryl Streep", .byPerson),
                EvalCase("Scarlett Johansson films", .byPerson),
                EvalCase("Quentin Tarantino movies", .byPerson),
                EvalCase("movies featuring Denzel Washington", .byPerson),
                EvalCase("films with Leonardo DiCaprio", .byPerson),
                EvalCase("movies by Steven Spielberg", .byPerson),
                EvalCase("Robert De Niro films", .byPerson),
                EvalCase("movies starring Margot Robbie", .byPerson),
                EvalCase("films featuring Anthony Hopkins", .byPerson),
                EvalCase("movies with both Brad Pitt and Edward Norton", .byPerson),
                EvalCase("Keanu Reeves movies", .byPerson),
                EvalCase("films directed by Greta Gerwig", .byPerson),
                EvalCase("movies with Ryan Gosling", .byPerson),
                EvalCase("Tom Cruise action movies", .byPerson, .browse),
                EvalCase("comedies with Adam Sandler", .byPerson, .browse),

                // similar — like a named title
                EvalCase("movies like Inception", .similar),
                EvalCase("shows similar to Breaking Bad", .similar),
                EvalCase("films like The Matrix", .similar),
                EvalCase("something like Stranger Things", .similar),
                EvalCase("movies similar to Fight Club", .similar),
                EvalCase("TV shows like Game of Thrones", .similar),
                EvalCase("films in the vein of Blade Runner", .similar),
                EvalCase("movies like Parasite", .similar),
                EvalCase("recommendations based on The Office", .similar),
                EvalCase("shows like The Crown", .similar),
                EvalCase("movies similar to Interstellar", .similar),
                EvalCase("something like John Wick", .similar),
                EvalCase("films like Pulp Fiction", .similar),
                EvalCase("shows like Black Mirror", .similar),
                EvalCase("movies like Get Out", .similar),

                // browse — attribute filters
                EvalCase("90s sci-fi movies", .browse),
                EvalCase("horror films from the 80s", .browse),
                EvalCase("French romantic comedies", .browse),
                EvalCase("short animated movies", .browse),
                EvalCase("highly rated documentaries", .browse),
                EvalCase("action movies from 2019", .browse),
                EvalCase("R-rated thrillers", .browse),
                EvalCase("Korean horror movies", .browse),
                EvalCase("long epic war films", .browse),
                EvalCase("Japanese animated films", .browse),
                EvalCase("British crime dramas", .browse),
                EvalCase("movies under 90 minutes", .browse),
                EvalCase("sci-fi movies from the 2010s", .browse),
                EvalCase("Spanish language films", .browse),
                EvalCase("movies released in 2020", .browse),
                EvalCase("comedies from the 2000s", .browse),
                EvalCase("recent thrillers", .browse),
                EvalCase("indie dramas", .browse),
                EvalCase("westerns from the 1960s", .browse),
                EvalCase("top rated movies of the 1990s", .browse, .list),

                // list — curated lists
                EvalCase("trending movies", .list),
                EvalCase("popular shows", .list),
                EvalCase("top rated movies", .list),
                EvalCase("what's in cinemas now", .list),
                EvalCase("new releases", .list),
                EvalCase("upcoming movies", .list),
                EvalCase("trending this week", .list),
                EvalCase("most popular TV series", .list),
                EvalCase("what's airing today", .list),
                EvalCase("now playing in theaters", .list),
                EvalCase("popular movies right now", .list),
                EvalCase("top rated TV shows", .list),
                EvalCase("trending people", .list),
                EvalCase("popular actors", .list),
                EvalCase("movies coming soon", .list),

                // mood — subjective (browse acceptable too)
                EvalCase("feel-good movies", .mood, .browse),
                EvalCase("something scary", .mood, .browse),
                EvalCase("cozy films for a rainy day", .mood, .browse),
                EvalCase("uplifting movies", .mood, .browse),
                EvalCase("a tearjerker", .mood, .browse),
                EvalCase("something funny to watch", .mood, .browse),
                EvalCase("comfort movies", .mood, .browse),
                EvalCase("date night movies", .mood, .browse),
                EvalCase("something light-hearted", .mood, .browse),
                EvalCase("feel good shows", .mood, .browse),

                // out of scope
                EvalCase("a good book about space", outOfScope: true),
                EvalCase("best pizza recipe", outOfScope: true),
                EvalCase("weather tomorrow", outOfScope: true),
                EvalCase("how to change a tire", outOfScope: true),
                EvalCase("stock market news", outOfScope: true),
                EvalCase("what time is it", outOfScope: true),
                EvalCase("translate hello to French", outOfScope: true),
                EvalCase("directions to the airport", outOfScope: true)
            ]
        }

        @available(macOS 26, *)
        @Test("Planner intent-classification accuracy over the corpus")
        func evaluatePlannerAccuracy() async throws {
            let nls = CredentialHelper.shared.makeClient().naturalLanguageSearch
            let cases = Self.corpus()

            var correct = 0
            var perCategory: [String: (correct: Int, total: Int)] = [:]
            var misses: [String] = []

            for testCase in cases {
                let category = testCase.outOfScope ? "outOfScope" : "\(testCase.accept[0])"
                var bucket = perCategory[category] ?? (0, 0)
                bucket.total += 1

                let plan: SearchPlan
                do {
                    // Apply the same deterministic repair the executor does.
                    plan = try await SearchPlanExecutor.normalize(nls.plan(for: testCase.prompt))
                } catch {
                    misses.append("ERROR  \(testCase.prompt)  -> \(error)")
                    perCategory[category] = bucket
                    continue
                }

                let passed = testCase.outOfScope
                    ? !plan.isInScope
                    : (plan.isInScope && testCase.accept.contains(plan.intent))

                if passed {
                    correct += 1
                    bucket.correct += 1
                } else {
                    let want = testCase.outOfScope ? "outOfScope" : "\(testCase.accept[0])"
                    misses.append("MISS \(testCase.prompt) | want \(want) got \(plan.intent) "
                        + "title=\(plan.title ?? "-") people=\(plan.people) "
                        + "list=\(String(describing: plan.list)) inScope=\(plan.isInScope)")
                }

                perCategory[category] = bucket
            }

            print("\n===== Planner accuracy: \(correct)/\(cases.count) "
                + "(\(Int(Double(correct) / Double(cases.count) * 100))%) =====")
            for key in perCategory.keys.sorted() {
                let bucket = try #require(perCategory[key])
                print(String(format: "  %-12@  %2d/%2d", key as NSString, bucket.correct, bucket.total))
            }
            print("----- misses (\(misses.count)) -----")
            for miss in misses {
                print("  \(miss)")
            }
            print("=====================================\n")
        }

    }
#endif
