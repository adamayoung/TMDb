//
//  KeyedDecodingContainer+NonEmpty.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension KeyedDecodingContainer {

    ///
    /// Decodes a `Date` value for the given key, treating an empty string as `nil`.
    ///
    /// Some TMDb endpoints represent an absent date as an empty string rather than
    /// omitting the key or using `null`. Decoding an empty string directly as a `Date`
    /// would fail, so this first peeks at the raw string and short-circuits to `nil`
    /// when it is empty, before decoding the `Date` (applying the decoder's configured
    /// date decoding strategy) for a non-empty value.
    ///
    /// - Parameter key: The key to decode the date for.
    ///
    /// - Returns: The decoded `Date`, or `nil` if the key is absent, its value is
    /// `null`, or its value is an empty string.
    ///
    /// - Throws: `DecodingError` if the value is present, non-empty and fails to
    /// decode as a `Date`.
    ///
    func decodeNonEmptyDateIfPresent(forKey key: Key) throws -> Date? {
        guard let stringValue = try decodeIfPresent(String.self, forKey: key), !stringValue.isEmpty
        else {
            return nil
        }

        return try decodeIfPresent(Date.self, forKey: key)
    }

    ///
    /// Decodes a `URL` value for the given key, treating an empty string as `nil`.
    ///
    /// Some TMDb endpoints represent an absent URL as an empty string rather than
    /// omitting the key or using `null`. Decoding an empty string directly as a `URL`
    /// would fail, so this first peeks at the raw string and short-circuits to `nil`
    /// when it is empty, before decoding the `URL` for a non-empty value.
    ///
    /// - Parameter key: The key to decode the URL for.
    ///
    /// - Returns: The decoded `URL`, or `nil` if the key is absent, its value is
    /// `null`, or its value is an empty string.
    ///
    /// - Throws: `DecodingError` if the value is present, non-empty and fails to
    /// decode as a `URL`.
    ///
    func decodeNonEmptyURLIfPresent(forKey key: Key) throws -> URL? {
        guard let stringValue = try decodeIfPresent(String.self, forKey: key), !stringValue.isEmpty
        else {
            return nil
        }

        return try decodeIfPresent(URL.self, forKey: key)
    }

}
