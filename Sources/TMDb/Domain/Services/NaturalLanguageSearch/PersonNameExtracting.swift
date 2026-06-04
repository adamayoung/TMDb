//
//  PersonNameExtracting.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Extracts person names that literally appear in a prompt.
///
/// Span-bounded by construction — it can only return text present in the input,
/// so it never invents people.
///
protocol PersonNameExtracting: Sendable {

    func people(in prompt: String) -> [String]

}

#if canImport(NaturalLanguage)
    import NaturalLanguage

    ///
    /// A ``PersonNameExtracting`` backed by `NLTagger`'s named-entity recognition.
    ///
    /// A fresh `NLTagger` is created per call (it is not `Sendable` and must not
    /// be shared across threads), keeping this type a safe `Sendable` value.
    ///
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
    struct NLTaggerPersonNameExtractor: PersonNameExtracting {

        func people(in prompt: String) -> [String] {
            let tagger = NLTagger(tagSchemes: [.nameType])
            tagger.string = prompt
            let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

            var names: [String] = []
            tagger.enumerateTags(
                in: prompt.startIndex ..< prompt.endIndex,
                unit: .word,
                scheme: .nameType,
                options: options
            ) { tag, range in
                if tag == .personalName {
                    let name = String(prompt[range]).trimmingCharacters(in: .whitespaces)
                    if !name.isEmpty {
                        names.append(name)
                    }
                }
                return true
            }
            return names
        }

    }
#endif
