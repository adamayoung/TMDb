//
//  MoodLexicon.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A hand-authored mapping from subjective mood terms to concrete genres and a
/// minimum rating.
///
/// Subjective moods have no ground truth, so they are mapped deterministically
/// here rather than left to the language model to interpret freely.
///
enum MoodLexicon {

    ///
    /// The genres and minimum rating a mood term maps to.
    ///
    struct Mapping: Equatable {
        let genres: [String]
        let minRating: Double?
    }

    private static let mappings: [String: Mapping] = [
        "feel-good": Mapping(genres: ["Comedy", "Family"], minRating: 6.5),
        "feel good": Mapping(genres: ["Comedy", "Family"], minRating: 6.5),
        "cozy": Mapping(genres: ["Comedy", "Romance", "Family"], minRating: 6.0),
        "comfort": Mapping(genres: ["Comedy", "Family"], minRating: 6.0),
        "date night": Mapping(genres: ["Romance", "Comedy"], minRating: 6.0),
        "scary": Mapping(genres: ["Horror", "Thriller"], minRating: nil),
        "uplifting": Mapping(genres: ["Drama", "Family"], minRating: 7.0),
        "tearjerker": Mapping(genres: ["Drama", "Romance"], minRating: 7.0)
    ]

    ///
    /// Returns the mapping for a mood term, if one is known.
    ///
    /// - Parameter term: The mood term, matched case-insensitively.
    ///
    /// - Returns: The mapping, or `nil` if the term is unknown.
    ///
    static func mapping(for term: String) -> Mapping? {
        mappings[term.lowercased()]
    }

    ///
    /// The set of known mood terms, for constraining model output.
    ///
    static var knownTerms: [String] {
        Array(mappings.keys)
    }

}
