//
//  MovieReleaseDatesByCountry.swift
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
/// A model representing movie release dates for a specific country.
///
public struct MovieReleaseDatesByCountry: Codable, Equatable, Hashable, Sendable {

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// Release dates for the country.
    ///
    public let releaseDates: [ReleaseDate]

    ///
    /// Creates a movie release dates by country object.
    ///
    /// - Parameters:
    ///    - countryCode: ISO 3166-1 country code.
    ///    - releaseDates: Release dates for the country.
    ///
    public init(countryCode: String, releaseDates: [ReleaseDate]) {
        self.countryCode = countryCode
        self.releaseDates = releaseDates
    }

}

extension MovieReleaseDatesByCountry {

    private enum CodingKeys: String, CodingKey {
        case countryCode = "iso31661"
        case releaseDates
    }

}
