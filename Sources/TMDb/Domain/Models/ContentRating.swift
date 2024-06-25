//
//  Company.swift
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
/// A model representing the content rating.
///
public struct ContentRating: Codable, Equatable, Hashable, Sendable {

    ///
    /// The tv show's identifier
    ///
    public let id: Int

    ///
    /// ?
    ///
    public let descriptors: [String]

    ///
    /// The ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// The content rating of the tv show
    ///
    public let rating: String

    /// Creates a content rating object.
    ///
    /// - Parameters:
    ///    - id: the ID of the show.
    ///    - descriptors: Array of....
    ///    - countryCode: ISO 3166-1 country code.
    ///    - rating: The content rating of the tv show
    ///
    public init(id: Int, descriptors: [String], countryCode: String, rating: String) {
        self.id = id
        self.descriptors = descriptors
        self.countryCode = countryCode
        self.rating = rating
    }
}

extension ContentRating {
    private enum CodingKeys: String, CodingKey {
        case id
        case rating
        case descriptors
        case countryCode = "iso31661"
    }
}
