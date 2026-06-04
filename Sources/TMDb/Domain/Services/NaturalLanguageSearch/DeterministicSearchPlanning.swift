//
//  DeterministicSearchPlanning.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A deterministic, synchronous planner that returns a confident ``SearchPlan``
/// or `nil` to abstain (let the fallback decide).
///
protocol DeterministicSearchPlanning: Sendable {

    func confidentPlan(for prompt: String) -> SearchPlan?

}
