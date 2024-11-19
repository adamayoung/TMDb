//
//  VideoType.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    /// - Throws: ``DecodingError.typeMismatch`` if the encountered encoded value is not convertible to the requested type.
    /// - Throws: ``DecodingError.keyNotFound`` if self does not have an entry for the given key.
    /// - Throws: ``DecodingError.valueNotFound`` if self has a null entry for the given key.
    ///
    public init(from decoder: Decoder) throws {
        self =
            try VideoType(rawValue: decoder.singleValueContainer().decode(RawValue.self))
            ?? .unknown
    }

}
