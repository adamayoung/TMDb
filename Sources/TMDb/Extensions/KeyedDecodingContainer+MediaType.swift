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
            throw DecodingError.unknownMediaType(
                rawValue: rawValue,
                codingPath: codingPath + [key]
            )
        }

        return mediaType
    }

    ///
    /// Decodes an array for the given key, skipping only those elements whose media
    /// type this library does not model.
    ///
    /// Every other decode failure propagates. That is the whole point: an element
    /// dropped for any other reason is a decoder defect, and swallowing it turns a
    /// regression into a quietly short page with no signal at all.
    ///
    /// - Parameters:
    ///    - type: The element type to decode.
    ///    - key: The key to decode the array for.
    ///
    /// - Returns: The decoded elements, and how many were skipped. An absent key or
    /// a `null` decodes as an empty array with a zero count.
    ///
    /// - Throws: `DecodingError` if the value is not an array, or if any element
    /// fails to decode for a reason other than an unmodelled media type.
    ///
    func decodeSkippingUnknownMediaTypes<Element: Decodable>(
        _ type: Element.Type,
        forKey key: Key
    ) throws -> (elements: [Element], dropped: Int) {
        let result = try decodeSkippingUnknownMediaTypesIfPresent(type, forKey: key)

        return (result.elements ?? [], result.dropped)
    }

    ///
    /// Decodes an optional array for the given key, skipping only those elements whose
    /// media type this library does not model.
    ///
    /// Behaves as ``decodeSkippingUnknownMediaTypes(_:forKey:)`` except that an absent
    /// key decodes as `nil` rather than an empty array, preserving the distinction for
    /// a model whose property is itself optional.
    ///
    /// - Parameters:
    ///    - type: The element type to decode.
    ///    - key: The key to decode the array for.
    ///
    /// - Returns: The decoded elements, or `nil` if the key is absent, and how many
    /// were skipped.
    ///
    /// - Throws: `DecodingError` if the value is not an array, or if any element
    /// fails to decode for a reason other than an unmodelled media type.
    ///
    func decodeSkippingUnknownMediaTypesIfPresent<Element: Decodable>(
        _: Element.Type,
        forKey key: Key
    ) throws -> (elements: [Element]?, dropped: Int) {
        guard
            let wrapped = try decodeIfPresent(
                [UnknownMediaTypeTolerant<Element>].self, forKey: key
            )
        else {
            return (nil, 0)
        }

        let elements = wrapped.compactMap(\.value)

        return (elements, wrapped.count - elements.count)
    }

}

///
/// A decoding wrapper that skips an element whose media type this library does not
/// model, and only that.
///
/// Decoding does not throw for that one case, which is what consumes the element so
/// the surrounding array carries on. Every other error propagates unchanged.
///
private struct UnknownMediaTypeTolerant<Wrapped: Decodable>: Decodable {

    let value: Wrapped?

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            self.value = try container.decode(Wrapped.self)
        } catch let error as DecodingError where error.unknownMediaType != nil {
            self.value = nil
        }
    }

}
