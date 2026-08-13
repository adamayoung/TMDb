//
//  SearchDegradation.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A reason a natural-language search result may be partial or approximate.
///
/// Degradations are computed deterministically during execution. They are not a
/// model-reported confidence score; each one describes a concrete way the
/// results differ from a literal interpretation of the prompt.
///
/// This vocabulary grows as the planner learns new ways to approximate a prompt.
/// Cover the degradations you render explicitly and handle the rest with a
/// `default:` — a new kind arrives as ``other(_:)`` rather than as a new case, so
/// a `switch` written today keeps compiling.
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

    /// The initial query returned nothing, so some constraints (companies, dates,
    /// genres) were dropped to find results.
    case relaxedConstraints

    /// One or more titles or franchises were excluded from results.
    case excludedTermsApplied([String])

    /// The model rejected the prompt, so a literal text search was used instead.
    case planRejectedUsedLiteralSearch

    /// The model refused the prompt; the associated message explains why.
    case refusalExplained(String)

    ///
    /// A degradation this version of the library does not model.
    ///
    /// This is a reserved growth slot, and it is what keeps the rest of this
    /// vocabulary stable: a new kind of degradation ships **here** in a minor
    /// release, carrying a stable identifier, and is promoted to a case of its
    /// own at the next major version. Without it, every new degradation would
    /// break exhaustive `switch`es downstream.
    ///
    /// The associated value identifies the kind for logging and diagnostics. It
    /// is not display copy — render it the way you would render a degradation you
    /// do not recognise.
    ///
    case other(String)

}
