//
//  ReleaseDate.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// A model representing a movie release date.
///
public struct ReleaseDate: Codable, Equatable, Hashable, Sendable {

    ///
    /// Content rating or certification (e.g., PG-13, R).
    ///
    public let certification: String

    ///
    /// Descriptors providing additional context about the content rating (e.g., "Violence", "Language").
    ///
    public let descriptors: [String]

    ///
    /// ISO 639-1 language code.
    ///
    public let languageCode: String?

    ///
    /// Additional notes about the release (e.g., festival name, location).
    ///
    public let note: String?

    ///
    /// Release date.
    ///
    public let releaseDate: Date

    ///
    /// Release type.
    ///
    public let type: ReleaseType

    ///
    /// Creates a release date object.
    ///
    /// - Parameters:
    ///    - certification: Content rating or certification.
    ///    - descriptors: Descriptors providing additional context about the content rating.
    ///    - languageCode: ISO 639-1 language code.
    ///    - note: Additional notes about the release.
    ///    - releaseDate: Release date.
    ///    - type: Release type.
    ///
    public init(
        certification: String,
        descriptors: [String] = [],
        languageCode: String? = nil,
        note: String? = nil,
        releaseDate: Date,
        type: ReleaseType
    ) {
        self.certification = certification
        self.descriptors = descriptors
        self.languageCode = languageCode
        self.note = note
        self.releaseDate = releaseDate
        self.type = type
    }

}

extension ReleaseDate {

    private enum CodingKeys: String, CodingKey {
        case certification
        case descriptors
        case languageCode = "iso6391"
        case note
        case releaseDate
        case type
    }

    ///
    /// Creates a release date object by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if decoding fails.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.certification = try container.decode(String.self, forKey: .certification)
        self.descriptors = try container.decode([String].self, forKey: .descriptors)
        self.languageCode = try container.decodeIfPresent(String.self, forKey: .languageCode)
        self.note = try container.decodeIfPresent(String.self, forKey: .note)

        // Decode release date using ISO8601DateFormatter
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .releaseDate,
                in: container,
                debugDescription: "Date string does not match ISO8601 format: \(dateString)"
            )
        }

        self.releaseDate = date
        self.type = try container.decode(ReleaseType.self, forKey: .type)
    }

}
