//
//  String+Validation.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension String {

    ///
    /// Validates that the string is not empty once leading and trailing
    /// whitespace and newlines are trimmed.
    ///
    /// Use this to guard a public API boundary that takes a `String` (or a
    /// `String`-backed identifier) against empty or whitespace-only input, so the
    /// degenerate value is rejected before a request is built.
    ///
    /// - Parameter message: The message for the thrown ``TMDbError/badRequest(_:)``.
    ///
    /// - Throws: ``TMDbError/badRequest(_:)`` if the string is empty or contains
    ///   only whitespace.
    ///
    func validateNotEmpty(message: String) throws(TMDbError) {
        guard !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw .badRequest(message)
        }
    }

}
