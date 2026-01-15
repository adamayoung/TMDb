//
//  CollectionTranslationData.swift
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
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// A model representing collection translation data.
///
public struct CollectionTranslationData: Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection title.
    ///
    public let title: String

    ///
    /// Collection overview.
    ///
    public let overview: String

    ///
    /// Collection's home page URL.
    ///
    public let homepageURL: URL?

    ///
    /// Creates a collection translation data object.
    ///
    /// - Parameters:
    ///    - title: Collection title.
    ///    - overview: Collection overview.
    ///    - homepageURL: Collection's home page URL.
    ///
    public init(
        title: String,
        overview: String,
        homepageURL: URL? = nil
    ) {
        self.title = title
        self.overview = overview
        self.homepageURL = homepageURL
    }

}

extension CollectionTranslationData {

    private enum CodingKeys: String, CodingKey {
        case title
        case overview
        case homepageURL = "homepage"
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError` if decoding fails.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)

        let homepageURLString = try container.decodeIfPresent(String.self, forKey: .homepageURL)
        self.homepageURL = try {
            guard let homepageURLString, !homepageURLString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(URL.self, forKey: .homepageURL)
        }()
    }

}
