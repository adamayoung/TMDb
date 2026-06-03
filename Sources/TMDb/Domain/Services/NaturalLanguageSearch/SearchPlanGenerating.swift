//
//  SearchPlanGenerating.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A type that turns a natural-language prompt into a ``SearchPlan``.
///
/// This is the seam between the deterministic search machinery and the on-device
/// language model. The live implementation is backed by Foundation Models; tests
/// provide a deterministic stand-in.
///
protocol SearchPlanGenerating: Sendable {

    ///
    /// The availability of the underlying model.
    ///
    var availability: NaturalLanguageSearchAvailability { get }

    ///
    /// Generates a plan for a prompt.
    ///
    /// - Parameter prompt: The natural-language prompt.
    ///
    /// - Throws: ``NaturalLanguageSearchError`` if generation fails.
    ///
    /// - Returns: The generated plan.
    ///
    func plan(for prompt: String) async throws -> SearchPlan

}
