//
//  ScreenedTheatricallyResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV episode that has been screened theatrically.
///
public struct ScreenedTheatricallyResult: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// Episode identifier.
    ///
    public let id: Int

    ///
    /// Episode number.
    ///
    public let episodeNumber: Int

    ///
    /// Season number.
    ///
    public let seasonNumber: Int

    ///
    /// Creates a screened theatrically result object.
    ///
    /// - Parameters:
    ///    - id: Episode identifier.
    ///    - episodeNumber: Episode number.
    ///    - seasonNumber: Season number.
    ///
    public init(
        id: Int,
        episodeNumber: Int,
        seasonNumber: Int
    ) {
        self.id = id
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
    }

}
