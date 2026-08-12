//
//  CreditType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a credit type.
///
public enum CreditType: String, Codable, Equatable, Hashable, Sendable {

    ///
    /// Cast credit type.
    ///
    case cast

    ///
    /// Crew credit type.
    ///
    case crew

    ///
    /// Creator credit type.
    ///
    /// TMDb uses this for the creator of a TV series, alongside a `department`
    /// and `job` of `Creator`.
    ///
    case creator

    ///
    /// Unknown.
    ///
    /// Used when TMDb returns a credit type this library does not yet model,
    /// so decoding a ``Credit`` does not fail on an unrecognised value.
    ///
    case unknown

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// An unrecognised raw value decodes to ``unknown`` rather than throwing.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to
    /// the requested type.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry.
    ///
    public init(from decoder: Decoder) throws {
        self =
            try CreditType(rawValue: decoder.singleValueContainer().decode(RawValue.self))
            ?? .unknown
    }

}
