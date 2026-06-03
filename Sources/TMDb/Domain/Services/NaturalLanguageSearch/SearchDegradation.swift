//
//  SearchDegradation.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A reason a natural-language search result may be partial or approximate.
///
/// Degradations are computed deterministically during execution. They are not a
/// model-reported confidence score; each one describes a concrete way the
/// results differ from a literal interpretation of the prompt.
///
public enum SearchDegradation: Sendable, Equatable {

    /// A genre name could not be matched to a TMDb genre.
    case unresolvedGenre(String)

    /// A person name could not be matched to a TMDb person.
    case unresolvedPerson(String)

    /// A company name could not be matched to a TMDb company.
    case unresolvedCompany(String)

    /// A subjective mood term was approximated to genres.
    case moodApproximated(String)

    /// The prompt was too vague to form a specific query; a default was used.
    case underspecified

    /// One or more titles or franchises were excluded from results.
    case excludedTermsApplied([String])

    /// The model rejected the prompt, so a literal text search was used instead.
    case planRejectedUsedLiteralSearch

    /// The model refused the prompt; the associated message explains why.
    case refusalExplained(String)

}
