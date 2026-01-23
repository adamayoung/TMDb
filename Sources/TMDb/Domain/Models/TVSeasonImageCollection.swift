//
//  TVSeasonImageCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV season image collection.
///
public struct TVSeasonImageCollection: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Season images.
    ///
    public let posters: [ImageMetadata]

    ///
    /// Creates a TV season image collection.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - posters: Still images.
    ///
    public init(id: Int, posters: [ImageMetadata]) {
        self.id = id
        self.posters = posters
    }

}
