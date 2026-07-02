//
//  TMDbClientNaturalLanguageSearchTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(NaturalLanguage)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.naturalLanguageSearch))
    struct TMDbClientNaturalLanguageSearchTests {

        private let client = TMDbClient(apiKey: "test-api-key")

        @Test("naturalLanguageSearch constructs an available service")
        func naturalLanguageSearchConstructsAvailableService() {
            // Exercises the full property graph — including the availability-gated
            // Foundation Models fallback wiring — so the accessor stays covered.
            #expect(client.naturalLanguageSearch.availability == .available)
        }

    }
#endif
