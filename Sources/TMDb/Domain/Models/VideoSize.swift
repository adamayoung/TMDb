//
//  VideoSize.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a video size.
///
public enum VideoSize: Int, Codable, Equatable, Hashable, Sendable {

    ///
    /// 360.
    ///
    case s360 = 360

    ///
    /// 480.
    ///
    case s480 = 480

    ///
    /// 720.
    ///
    case s720 = 720

    ///
    /// 1080.
    ///
    case s1080 = 1080

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
            try VideoSize(rawValue: decoder.singleValueContainer().decode(RawValue.self))
            ?? .unknown
    }

}
