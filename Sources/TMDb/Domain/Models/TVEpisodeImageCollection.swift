//
//  TVEpisodeImageCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV episode image collection.
///
public struct TVEpisodeImageCollection: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Episode images.
    ///
    public let stills: [ImageMetadata]

    ///
    /// Creates a TV episode image collection.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - stills: Still images.
    ///
    public init(id: Int, stills: [ImageMetadata]) {
        self.id = id
        self.stills = stills
    }

}
