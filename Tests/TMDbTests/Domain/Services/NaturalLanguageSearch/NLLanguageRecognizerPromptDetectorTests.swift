//
//  NLLanguageRecognizerPromptDetectorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(NaturalLanguage)
    import Foundation
    import Testing
    @testable import TMDb

    ///
    /// Coverage for the production language detector. `NLLanguageRecognizer` is a
    /// built-in identifier (no downloadable model), so these assertions run
    /// directly on the host rather than under `withKnownIssue`.
    ///
    @Suite("NLLanguageRecognizerPromptDetector")
    struct NLLanguageRecognizerPromptDetectorTests {

        private let detector = NLLanguageRecognizerPromptDetector()

        @Test("flags a clearly non-English sentence")
        func flagsNonEnglish() {
            #expect(detector.isConfidentlyNonEnglish("un film policier français avec une intrigue captivante"))
        }

        @Test("does not flag a clearly English sentence")
        func allowsEnglish() {
            #expect(!detector.isConfidentlyNonEnglish("a gripping crime movie with a great cast"))
        }

        @Test("does not flag a short, possibly foreign, title")
        func allowsShortTitle() {
            // Bare titles are legitimate `find` queries and are too short to judge.
            #expect(!detector.isConfidentlyNonEnglish("Amélie"))
            #expect(!detector.isConfidentlyNonEnglish("La Haine"))
        }

        @Test("does not flag an empty or whitespace-only prompt")
        func allowsEmpty() {
            #expect(!detector.isConfidentlyNonEnglish(""))
            #expect(!detector.isConfidentlyNonEnglish("   "))
        }

        @Test("respects the confidence threshold")
        func respectsConfidenceThreshold() {
            // An unreachable confidence bar means even a clearly non-English
            // sentence is not flagged — exercising the confidence gate directly.
            let strict = NLLanguageRecognizerPromptDetector(minimumConfidence: 1.0)
            #expect(!strict.isConfidentlyNonEnglish("un film policier français avec une intrigue captivante"))
        }

    }
#endif
