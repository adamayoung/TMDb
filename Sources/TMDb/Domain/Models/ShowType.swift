//
//  ShowType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a show type.
///
public enum ShowType: String, Codable, Sendable {

    ///
    /// Movie.
    ///
    case movie

    ///
    /// TV series.
    ///
    case tvSeries = "tv"

    ///
    /// Unknown.
    ///
    /// Used when TMDb returns a media type this library does not yet model, so
    /// decoding a list or a search result does not fail on an unrecognised
    /// entry.
    ///
    /// This value is **decode-only**. Passing it back to a method that takes a
    /// show type — ``V4ListService/itemStatus(forMedia:ofType:inList:accessToken:)``,
    /// ``V4ListService/addItems(_:toList:accessToken:)``,
    /// ``V4ListService/updateItems(_:inList:accessToken:)`` or
    /// ``V4ListService/removeItems(_:fromList:accessToken:)`` — throws
    /// ``TMDbError/badRequest(_:)`` rather than sending a media type TMDb cannot
    /// interpret.
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
            try ShowType(rawValue: decoder.singleValueContainer().decode(RawValue.self))
            ?? .unknown
    }

}
