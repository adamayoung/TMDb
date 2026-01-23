//
//  ReleaseType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a movie release type.
///
public enum ReleaseType: Int, Codable, Equatable, Hashable, Sendable {

    ///
    /// Premiere.
    ///
    case premiere = 1

    ///
    /// Theatrical (limited).
    ///
    case limited = 2

    ///
    /// Theatrical.
    ///
    case theatrical = 3

    ///
    /// Digital.
    ///
    case digital = 4

    ///
    /// Physical.
    ///
    case physical = 5

    ///
    /// TV.
    ///
    case tv = 6

    ///
    /// Unknown.
    ///
    case unknown

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested
    /// type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    ///
    public init(from decoder: Decoder) throws {
        self =
            try ReleaseType(rawValue: decoder.singleValueContainer().decode(RawValue.self))
            ?? .unknown
    }

}
