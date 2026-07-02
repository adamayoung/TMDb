//
//  PromptLanguageDetecting.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Detects whether a prompt is written in a language the deterministic planner
/// cannot interpret.
///
/// The rule-based planner and its lexicon are English-only, so a confidently
/// non-English prompt should not be forced through them (it would be
/// mis-parsed and silently emitted as a literal `find`). Instead the planner
/// abstains, letting the language-model fallback — which is multilingual — take
/// over, or, failing that, run a plain text search.
///
protocol PromptLanguageDetecting: Sendable {

    ///
    /// Whether the prompt is confidently in a language other than English.
    ///
    /// Implementations should be conservative: short prompts (typically bare,
    /// often foreign, titles such as `"Amélie"`) must not be judged non-English,
    /// since they are legitimate `find` queries and language detection is
    /// unreliable on little text.
    ///
    /// - Parameter prompt: The natural-language prompt.
    ///
    /// - Returns: `true` only when the dominant language is confidently not
    ///   English; `false` when English, undetermined, or too short to judge.
    ///
    func isConfidentlyNonEnglish(_ prompt: String) -> Bool

}

#if canImport(NaturalLanguage)
    import NaturalLanguage

    ///
    /// A ``PromptLanguageDetecting`` backed by `NLLanguageRecognizer`.
    ///
    /// A fresh `NLLanguageRecognizer` is created per call (it is stateful and not
    /// `Sendable`), keeping this type a safe `Sendable` value.
    ///
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
    struct NLLanguageRecognizerPromptDetector: PromptLanguageDetecting {

        /// Prompts with fewer words than this are never judged non-English: they
        /// are usually bare titles (often foreign) that must stay valid `find`
        /// queries, and `NLLanguageRecognizer` is unreliable on very short text.
        private let minimumWordCount: Int

        /// The minimum dominant-language probability required to abstain, so only
        /// a confident non-English reading routes away from the English planner.
        private let minimumConfidence: Double

        init(minimumWordCount: Int = 3, minimumConfidence: Double = 0.85) {
            self.minimumWordCount = minimumWordCount
            self.minimumConfidence = minimumConfidence
        }

        func isConfidentlyNonEnglish(_ prompt: String) -> Bool {
            let wordCount = prompt.split(whereSeparator: \.isWhitespace).count
            guard wordCount >= minimumWordCount else {
                return false
            }

            let recognizer = NLLanguageRecognizer()
            recognizer.processString(prompt)

            guard let (language, confidence) = recognizer
                .languageHypotheses(withMaximum: 1)
                .max(by: { $0.value < $1.value })
            else {
                return false
            }

            return language != .english && confidence >= minimumConfidence
        }

    }
#endif
