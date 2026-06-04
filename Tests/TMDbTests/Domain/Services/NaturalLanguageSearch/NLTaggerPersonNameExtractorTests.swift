//
//  NLTaggerPersonNameExtractorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(NaturalLanguage)
    import Foundation
    import Testing
    @testable import TMDb

    ///
    /// Coverage for the production NER extractor. Apple's on-device model varies
    /// across OS versions, so assertions are tolerant: they check membership and
    /// span-boundedness rather than exact token spans.
    ///
    @Suite("NLTaggerPersonNameExtractor")
    struct NLTaggerPersonNameExtractorTests {

        private let extractor = NLTaggerPersonNameExtractor()

        @Test("extracts a single full name embedded in a prompt")
        func singleName() {
            let names = extractor.people(in: "movies with Tom Hanks")
            #expect(names.contains { $0.localizedCaseInsensitiveContains("Tom Hanks") })
        }

        @Test("extracts a name from a directed-by phrasing")
        func directedBy() {
            let names = extractor.people(in: "films directed by Christopher Nolan")
            #expect(names.contains { $0.localizedCaseInsensitiveContains("Christopher Nolan") })
        }

        @Test("extracts both names from a two-person prompt")
        func twoNames() {
            let names = extractor.people(in: "movies with Brad Pitt and Edward Norton")
            #expect(names.contains { $0.localizedCaseInsensitiveContains("Brad Pitt") })
            #expect(names.contains { $0.localizedCaseInsensitiveContains("Edward Norton") })
        }

        @Test("never returns text that is not present in the prompt")
        func spanBounded() {
            let prompt = "movies with Meryl Streep"
            for name in extractor.people(in: prompt) {
                #expect(prompt.localizedCaseInsensitiveContains(name))
            }
        }

        @Test("a prompt with no person names returns no spurious people")
        func noNames() {
            // Best-effort: a bare genre prompt should not yield a confident person.
            let names = extractor.people(in: "trending movies")
            #expect(!names.contains { $0.localizedCaseInsensitiveContains("trending") })
        }
    }
#endif
