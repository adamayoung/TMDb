//
//  ShowCrewCredit.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a combined crew credit - movie or TV series.
///
public enum ShowCrewCredit: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Show identifier.
    ///
    public var id: Int {
        switch self {
        case .movie(let credit):
            credit.id

        case .tvSeries(let credit):
            credit.id
        }
    }

    ///
    /// Movie crew credit.
    ///
    case movie(MovieCrewCredit)

    ///
    /// TV series crew credit.
    ///
    case tvSeries(TVSeriesCrewCredit)

}

extension ShowCrewCredit {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvSeries = "tv"
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry
    ///   for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for
    ///   the given key.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = try .movie(MovieCrewCredit(from: decoder))

        case .tvSeries:
            self = try .tvSeries(TVSeriesCrewCredit(from: decoder))
        }
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .movie(let credit):
            try container.encode(MediaType.movie.rawValue, forKey: .mediaType)
            try credit.encode(to: encoder)

        case .tvSeries(let credit):
            try container.encode(MediaType.tvSeries.rawValue, forKey: .mediaType)
            try credit.encode(to: encoder)
        }
    }

}
