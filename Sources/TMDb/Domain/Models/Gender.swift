//
//  Gender.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the gender of a person.
///
public enum Gender: Int, Codable, Equatable, Hashable, Sendable {

    ///
    /// An unknown gender.
    ///
    case unknown = 0

    ///
    /// A female.
    ///
    case female = 1

    ///
    /// A male.
    ///
    case male = 2

    ///
    /// Some other gender.
    ///
    case other = 3

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
            try Gender(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
