//
//  NaturalLanguageSearchService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for searching TMDb with natural language.
///
/// A prompt such as `"movies with Tom Hanks"` or `"cast of The Matrix"` is
/// interpreted on device into a structured plan, which is then executed against
/// TMDb to return matching movies, TV series, and people.
///
/// Interpretation is deterministic, using Apple's Natural Language framework,
/// and is available on every supported Apple platform. On devices with Apple
/// Intelligence, Foundation Models additionally handles fuzzier, compositional
/// prompts (for example `"uplifting 90s sci-fi under 2 hours"`); elsewhere such
/// prompts fall back to a plain multi-search.
///
public protocol NaturalLanguageSearchService: Sendable {

    ///
    /// The availability of on-device natural-language search.
    ///
    /// - Note: The default implementation always reports ``NaturalLanguageSearchAvailability/available``,
    ///   because deterministic interpretation is present on every supported Apple
    ///   platform. The ``NaturalLanguageSearchAvailability/unavailable(_:)`` cases
    ///   are therefore only reachable through a custom implementation.
    ///
    var availability: NaturalLanguageSearchAvailability { get }

    ///
    /// Interprets a prompt into a structured plan, without executing it.
    ///
    /// Useful for displaying or editing how a prompt was understood before
    /// running the search.
    ///
    /// - Parameter prompt: The natural-language prompt.
    ///
    /// - Throws: ``NaturalLanguageSearchError``.
    ///
    /// - Returns: The interpreted plan.
    ///
    func plan(for prompt: String) async throws -> SearchPlan

    ///
    /// Searches TMDb using a natural-language prompt.
    ///
    /// - Parameter prompt: The natural-language prompt.
    ///
    /// - Throws: ``NaturalLanguageSearchError``.
    ///
    /// - Returns: The matching movies, TV series, and people.
    ///
    func search(matching prompt: String) async throws -> NaturalLanguageSearchResult

}
