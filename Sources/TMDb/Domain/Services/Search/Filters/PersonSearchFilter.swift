//
//  PersonSearchFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A search filter when searching for people.
///
public struct PersonSearchFilter: Sendable {

    ///
    /// Include adult results.
    ///
    public let includeAdult: Bool?

    ///
    /// Creates a search filter for people searches.
    ///
    /// - Parameter includeAdult: Include adult results.
    ///
    public init(includeAdult: Bool? = nil) {
        self.includeAdult = includeAdult
    }

}
