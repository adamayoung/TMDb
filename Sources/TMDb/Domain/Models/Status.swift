//
//  Status.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a show's status.
///
public enum Status: String, Codable, Equatable, Hashable, Sendable {

    ///
    /// Rumoured.
    ///
    case rumoured = "Rumored"

    ///
    /// Planned.
    ///
    case planned = "Planned"

    ///
    /// In production.
    ///
    case inProduction = "In Production"

    ///
    /// Post production.
    ///
    case postProduction = "Post Production"

    ///
    /// Released.
    ///
    case released = "Released"

    ///
    /// Cancelled.
    ///
    case cancelled = "Canceled"

    ///
    /// Unknown.
    ///
    /// Used when TMDb returns a status value this library does not yet model,
    /// so decoding a `Movie` or `TVSeries` does not fail on an unrecognised
    /// status.
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
            try Status(rawValue: decoder.singleValueContainer().decode(RawValue.self))
            ?? .unknown
    }

}
