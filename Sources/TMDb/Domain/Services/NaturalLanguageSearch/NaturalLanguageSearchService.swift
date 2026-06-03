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
/// A prompt such as `"uplifting 90s sci-fi under 2 hours"` is interpreted by an
/// on-device language model into a structured plan, which is then executed
/// against TMDb to return matching movies, TV series, and people.
///
/// - Important: This relies on an on-device model available only on supported
///   Apple platforms with Apple Intelligence enabled. Check ``availability``
///   before use.
///
public protocol NaturalLanguageSearchService: Sendable {

    ///
    /// The availability of on-device natural-language search.
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
