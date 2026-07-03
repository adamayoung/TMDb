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

extension ImageCollection {

    ///
    /// Decodes an image collection from the wrapper object at `key`.
    ///
    /// The image append section wraps up to three arrays — `posters`, `logos`, and
    /// `backdrops` — each defaulting to empty when absent, so a wrapper carrying only
    /// some of them decodes into a collection with the rest empty.
    ///
    /// - Parameters:
    ///   - container: The container holding the `images` wrapper.
    ///   - key: The wrapper key. When absent, the initializer returns `nil`.
    ///   - id: The identifier of the owning entity.
    ///
    init?<Key: CodingKey>(
        from container: KeyedDecodingContainer<Key>,
        forKey key: Key,
        id: Int
    ) throws {
        guard container.contains(key) else {
            return nil
        }

        let nested = try container.nestedContainer(keyedBy: StringCodingKey.self, forKey: key)

        func images(_ name: String) throws -> [ImageMetadata] {
            try nested.decodeIfPresent([ImageMetadata].self, forKey: StringCodingKey(name)) ?? []
        }

        try self.init(
            id: id,
            posters: images("posters"),
            logos: images("logos"),
            backdrops: images("backdrops")
        )
    }

}
