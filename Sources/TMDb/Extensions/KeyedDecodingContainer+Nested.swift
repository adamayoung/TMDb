//
//  KeyedDecodingContainer+Nested.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension KeyedDecodingContainer {

    ///
    /// Decodes a value nested one level under `key` at `nestedKey`.
    ///
    /// Many TMDb append-to-response payloads wrap the appended value in a single-key
    /// object (e.g. `{ "results": [...] }`). This opens the wrapper object at `key` and
    /// decodes `nestedKey` from it, short-circuiting to `nil` when `key` is absent.
    ///
    /// - Parameters:
    ///   - type: The type to decode.
    ///   - key: The wrapper key. When absent, the result is `nil`.
    ///   - nestedKey: The key of the wrapped value inside the wrapper object.
    ///
    /// - Returns: The decoded value, or `nil` when `key` is absent (or the nested value is).
    ///
    func decodeNestedIfPresent<T: Decodable>(
        _ type: T.Type,
        forKey key: Key,
        nestedKey: String
    ) throws -> T? {
        guard contains(key) else {
            return nil
        }

        let nested = try nestedContainer(keyedBy: StringCodingKey.self, forKey: key)
        return try nested.decodeIfPresent(T.self, forKey: StringCodingKey(nestedKey))
    }

    ///
    /// Decodes an array nested one level under `key` at `nestedKey`, defaulting a
    /// missing nested value to an empty array.
    ///
    /// Like ``decodeNestedIfPresent(_:forKey:nestedKey:)`` but for a wrapped array whose
    /// absence (when the wrapper `key` *is* present) should be an empty array rather than
    /// `nil` — matching collections that are always constructed once the wrapper exists.
    ///
    /// - Parameters:
    ///   - elementType: The array element type to decode.
    ///   - key: The wrapper key. When absent, the result is `nil`.
    ///   - nestedKey: The key of the wrapped array inside the wrapper object.
    ///
    /// - Returns: The decoded array (empty if the nested value is absent), or `nil` when
    /// `key` is absent.
    ///
    func decodeNestedArrayIfPresent<Element: Decodable>(
        _ elementType: Element.Type,
        forKey key: Key,
        nestedKey: String
    ) throws -> [Element]? {
        guard contains(key) else {
            return nil
        }

        let nested = try nestedContainer(keyedBy: StringCodingKey.self, forKey: key)
        return try nested.decodeIfPresent([Element].self, forKey: StringCodingKey(nestedKey)) ?? []
    }

    ///
    /// Decodes the `cast` and `crew` arrays nested under `key`.
    ///
    /// The credits-shaped append sections (`credits`, `aggregate_credits`, and the
    /// person credit variants) all wrap two arrays, `{ "cast": [...], "crew": [...] }`,
    /// each defaulting to empty. The caller maps the result into its specific credits type.
    ///
    /// - Parameters:
    ///   - castType: The cast element type.
    ///   - crewType: The crew element type.
    ///   - key: The wrapper key. When absent, the result is `nil`.
    ///
    /// - Returns: The decoded cast and crew arrays, or `nil` when `key` is absent.
    ///
    func decodeCastAndCrewIfPresent<Cast: Decodable, Crew: Decodable>(
        _ castType: Cast.Type,
        _ crewType: Crew.Type,
        forKey key: Key
    ) throws -> (cast: [Cast], crew: [Crew])? {
        guard contains(key) else {
            return nil
        }

        let nested = try nestedContainer(keyedBy: StringCodingKey.self, forKey: key)
        let cast = try nested.decodeIfPresent([Cast].self, forKey: StringCodingKey("cast")) ?? []
        let crew = try nested.decodeIfPresent([Crew].self, forKey: StringCodingKey("crew")) ?? []
        return (cast, crew)
    }

}
