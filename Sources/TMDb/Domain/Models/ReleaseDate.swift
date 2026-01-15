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
    ///    - languageCode: ISO 639-1 language code.
    ///    - note: Additional notes about the release.
    ///    - releaseDate: Release date.
    ///    - type: Release type.
    ///
    public init(
        certification: String,
        languageCode: String? = nil,
        note: String? = nil,
        releaseDate: Date,
        type: ReleaseType
    ) {
        self.certification = certification
        self.languageCode = languageCode
        self.note = note
        self.releaseDate = releaseDate
        self.type = type
    }

}

extension ReleaseDate {

    private enum CodingKeys: String, CodingKey {
        case certification
        case languageCode = "iso6391"
        case note
        case releaseDate
        case type
    }

}
