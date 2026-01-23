//
//  CollectionImageCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection image collection.
///
/// A collection of poster and backdrop images for a collection.
///
public struct CollectionImageCollection: Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection identifier for these images.
    ///
    public let id: Int

    ///
    /// Poster images.
    ///
    public let posters: [ImageMetadata]

    ///
    /// Backdrop images.
    ///
    public let backdrops: [ImageMetadata]

    ///
    /// Creates a collection image collection object.
    ///
    /// - Parameters:
    ///    - id: Collection identifier for these images.
    ///    - posters: Poster images.
    ///    - backdrops: Backdrop images.
    ///
    public init(
        id: Int,
        posters: [ImageMetadata],
        backdrops: [ImageMetadata]
    ) {
        self.id = id
        self.posters = posters
        self.backdrops = backdrops
    }

}
