//
//  Double+Rating.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension Double {

    ///
    /// Validates that the value is a valid TMDb rating — within the range
    /// `0.5...10.0` and a multiple of `0.5`.
    ///
    /// Use this to guard a public `addRating` boundary against an out-of-range or
    /// off-step rating before a request is built.
    ///
    /// - Throws: ``TMDbError/invalidRating`` if the value is outside `0.5...10.0`
    ///   or not a multiple of `0.5`.
    ///
    func validateAsRating() throws(TMDbError) {
        guard (0.5 ... 10.0).contains(self), truncatingRemainder(dividingBy: 0.5) == 0 else {
            throw .invalidRating
        }
    }

}
