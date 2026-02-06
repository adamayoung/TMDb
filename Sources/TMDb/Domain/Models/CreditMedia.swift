//
//  CreditMedia.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the media associated with a credit.
///
public enum CreditMedia: Codable, Equatable, Hashable, Sendable {

    ///
    /// Movie media.
    ///
    case movie(CreditMovie)

    ///
    /// TV series media.
    ///
    case tvSeries(CreditTVSeries)

}

public extension CreditMedia {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        let mediaType = try container.decode(
            String.self,
            forKey: .mediaType
        )

        switch mediaType {
        case "movie":
            let movie = try CreditMovie(from: decoder)
            self = .movie(movie)

        case "tv":
            let tvSeries = try CreditTVSeries(from: decoder)
            self = .tvSeries(tvSeries)

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .mediaType,
                in: container,
                debugDescription:
                "Unknown media type: \(mediaType)"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(
            keyedBy: CodingKeys.self
        )

        switch self {
        case .movie(let movie):
            try container.encode(
                "movie", forKey: .mediaType
            )
            try movie.encode(to: encoder)

        case .tvSeries(let tvSeries):
            try container.encode(
                "tv", forKey: .mediaType
            )
            try tvSeries.encode(to: encoder)
        }
    }

}
