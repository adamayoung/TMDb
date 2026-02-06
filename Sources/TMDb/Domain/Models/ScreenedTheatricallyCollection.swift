//
//  ScreenedTheatricallyCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of TV episodes that have been screened theatrically.
///
public struct ScreenedTheatricallyCollection: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// TV series identifier.
    ///
    public let id: Int

    ///
    /// Screened theatrically results.
    ///
    public let results: [ScreenedTheatricallyResult]

    ///
    /// Creates a screened theatrically collection object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - results: Screened theatrically results.
    ///
    public init(
        id: Int,
        results: [ScreenedTheatricallyResult]
    ) {
        self.id = id
        self.results = results
    }

}
