//
//  AllMediaSearchFilter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A search filter when searching for all media.
///
public struct AllMediaSearchFilter: Sendable {

    ///
    /// Include adult results.
    ///
    public let includeAdult: Bool?

    ///
    /// Creates a search filter for all media searches.
    ///
    /// - Parameter includeAdult: Include adult results.
    ///
    public init(includeAdult: Bool? = nil) {
        self.includeAdult = includeAdult
    }

}
