//
//  VideoType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a video type.
///
public enum VideoType: String, Codable, Equatable, Hashable, Sendable {

    ///
    /// Trailer.
    ///
    case trailer = "Trailer"

    ///
    /// Teaser.
    ///
    case teaser = "Teaser"

    ///
    /// Clip.
    ///
    case clip = "Clip"

    ///
    /// Opening credits.
    ///
    case openingCredits = "Opening Credits"

    ///
    /// Featurette.
    ///
    case featurette = "Featurette"

    ///
    /// Behind the Scenes.
    ///
    case behindTheScenes = "Behind the Scenes"

    ///
    /// Bloopers.
    ///
    case bloopers = "Bloopers"

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
            try VideoType(rawValue: decoder.singleValueContainer().decode(RawValue.self))
            ?? .unknown
    }

}
