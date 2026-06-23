//
//  String+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension [String] {

    ///
    /// A sample list of strings, for use in tests and previews.
    ///
    /// Used as sample data for endpoints that return a list of primary
    /// translation identifiers (e.g. `en-US`).
    ///
    static var samples: [String] {
        ["en-US", "en-GB", "fr-FR"]
    }

}
