//
//  NaturalLanguageSearchEndToEndIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(NaturalLanguage)
    import Foundation
    import Testing
    @testable import TMDb

    ///
    /// End-to-end coverage for the deterministic NaturalLanguage planner: a sample
    /// of real prompts driven through `client.naturalLanguageSearch` against the
    /// live API. These exercise the full chain (classifier → NER → executor →
    /// TMDb) without the language model, so they are stable on every Apple runner.
    ///
    @Suite(
        .integrationGate,
        .serialized,
        .tags(.naturalLanguageSearch),
        .enabled(if: CredentialHelper.shared.hasAPIKey)
    )
    struct NaturalLanguageSearchEndToEndIntegrationTests {

        private var search: any NaturalLanguageSearchService {
            CredentialHelper.shared.makeClient().naturalLanguageSearch
        }

        @Test("the feature is available on all Apple platforms")
        func available() {
            #expect(search.availability == .available)
        }

        @Test("bare title returns the matching movie")
        func findTitle() async throws {
            let result = try await search.search(matching: "Fight Club")
            #expect(result.movies.contains { $0.title.localizedCaseInsensitiveContains("Fight Club") })
        }

        @Test("cast of a known film returns its cast")
        func castOf() async throws {
            let result = try await search.search(matching: "cast of The Matrix")
            #expect(result.people.contains { $0.name.localizedCaseInsensitiveContains("Keanu Reeves") })
        }

        @Test("director of a known film returns the director")
        func crewRole() async throws {
            let result = try await search.search(matching: "who directed Jurassic Park")
            #expect(result.people.contains { $0.name.localizedCaseInsensitiveContains("Spielberg") })
        }

        @Test("movies with a named actor returns results")
        func byPerson() async throws {
            let result = try await search.search(matching: "movies with Tom Hanks")
            #expect(!result.movies.isEmpty)
        }

        @Test("tv shows with a named actor returns results from person credits")
        func byPersonTV() async throws {
            // Exercises the person-credits path (discover/tv can't filter by person).
            let result = try await search.search(matching: "shows with Bryan Cranston")
            #expect(result.tvSeries.contains { $0.name.localizedCaseInsensitiveContains("Breaking Bad") })
        }

        @Test("similar to a known film returns results")
        func similar() async throws {
            let result = try await search.search(matching: "movies like The Matrix")
            #expect(!result.movies.isEmpty)
        }

        @Test("a curated list returns results")
        func list() async throws {
            let result = try await search.search(matching: "trending movies")
            #expect(!result.movies.isEmpty)
        }

        @Test("a non-English prompt degrades gracefully instead of throwing")
        func nonEnglishPrompt() async throws {
            // CI runners have no Apple Intelligence, so the multilingual language-model
            // fallback is unavailable. A confidently non-English prompt must therefore
            // abstain to a plain literal search — not be mis-parsed by the English
            // planner, and not throw `.unsupportedLanguage`. (The FM-backed multilingual
            // interpretation only runs on capable devices, which CI cannot exercise.)
            await #expect(throws: Never.self) {
                _ = try await search.search(matching: "films policiers français des années quatre-vingt-dix")
            }
        }

    }
#endif
