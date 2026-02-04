//
//  ImageCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an image collection.
///
/// A collection of poster and backdrop images for a movie or TV series.
///
public struct ImageCollection: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Movie or TV series identifier for these images.
    ///
    public let id: Int

    ///
    /// Poster images.
    ///
    public let posters: [ImageMetadata]

    ///
    /// Logo images.
    ///
    public let logos: [ImageMetadata]

    ///
    /// Backdrop images.
    ///
    public let backdrops: [ImageMetadata]

    ///
    /// Creates an image collection object.
    ///
    /// - Parameters:
    ///    - id: Movie or TV series identifier for these images.
    ///    - posters: Poster images.
    ///    - logos: Logo images.
    ///    - backdrops: Backdrop images.
    ///
    public init(
        id: Int,
        posters: [ImageMetadata],
        logos: [ImageMetadata],
        backdrops: [ImageMetadata]
    ) {
        self.id = id
        self.posters = posters
        self.logos = logos
        self.backdrops = backdrops
    }

}
