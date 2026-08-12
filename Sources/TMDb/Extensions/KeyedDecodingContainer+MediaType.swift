//
//  KeyedDecodingContainer+MediaType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension KeyedDecodingContainer {

    ///
    /// Decodes a media-type discriminator for the given key.
    ///
    /// This is the single place the package decides that a `media_type` is unmodelled.
    /// It decodes the raw string first, so an **absent** key, a `null`, or a non-string
    /// value all still produce a genuine `DecodingError` — only a well-formed string
    /// that no case matches yields ``UnknownMediaTypeError``, which a tolerant array
    /// skips and counts.
    ///
    /// Decoding the enum directly with `try?` would collapse all four of those cases
    /// into "unmodelled", silently reopening the unbounded tolerance this exists to
    /// remove.
    ///
    /// - Parameters:
    ///    - type: The discriminator type to decode.
    ///    - key: The key to decode the discriminator for.
    ///
    /// - Returns: The decoded discriminator.
    ///
    /// - Throws: ``UnknownMediaTypeError`` if the value is a string no case matches.
    /// - Throws: `DecodingError` if the key is absent, its value is `null`, or its
    /// value is not a string.
    ///
    func decodeMediaType<T: RawRepresentable>(
        _: T.Type,
        forKey key: Key
    ) throws -> T where T.RawValue == String {
        let rawValue = try decode(String.self, forKey: key)

        guard let mediaType = T(rawValue: rawValue) else {
            throw UnknownMediaTypeError(rawValue: rawValue)
        }

        return mediaType
    }

}
