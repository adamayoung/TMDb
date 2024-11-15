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
/// A model representing  a production company.
///
public struct Company: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Company identifier.
    ///
    public let id: Int

    ///
    /// Company name.
    ///
    public let name: String

    ///
    /// Description of company.
    ///
    public let description: String

    ///
    /// Location of the company's headquarters.
    ///
    public let headquarters: String

    ///
    /// Company's homepage.
    ///
    public let homepageURL: URL?

    ///
    /// Company's logo path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let logoPath: URL

    ///
    /// Origin country.
    ///
    public let originCountry: String

    ///
    /// Parent company.
    ///
    public let parentCompany: Parent?

    ///
    /// Creates a company object.
    ///
    /// - Parameters:
    ///   - id: Company identifier.
    ///   - name: Company name.
    ///   - description: Description of company.
    ///   - headquarters: Location of the company's headquarters.
    ///   - homepageURL: Company's homepage.
    ///   - logoPath: Company's logo path.
    ///   - originCountry: Origin country.
    ///   - parentCompany: Parent company.
    ///
    public init(
        id: Int,
        name: String,
        description: String,
        headquarters: String,
        homepageURL: URL? = nil,
        logoPath: URL,
        originCountry: String,
        parentCompany: Parent? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.headquarters = headquarters
        self.homepageURL = homepageURL
        self.logoPath = logoPath
        self.originCountry = originCountry
        self.parentCompany = parentCompany
    }

}

extension Company {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case headquarters
        case homepageURL = "homepage"
        case logoPath
        case originCountry
        case parentCompany
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.headquarters = try container.decode(String.self, forKey: .headquarters)
        // Need to deal with empty strings - URL decoding will fail with an empty string
        let homepageURLString = try container.decodeIfPresent(String.self, forKey: .homepageURL)
        self.homepageURL = try {
            guard let homepageURLString, !homepageURLString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(URL.self, forKey: .homepageURL)
        }()
        self.logoPath = try container.decode(URL.self, forKey: .logoPath)
        self.originCountry = try container.decode(String.self, forKey: .originCountry)
        self.parentCompany = try container.decodeIfPresent(Parent.self, forKey: .parentCompany)
    }

}

extension Company {

    ///
    /// A model representing a parent company.
    ///
    public struct Parent: Identifiable, Codable, Equatable, Hashable, Sendable {

        ///
        /// Company identifier.
        ///
        public let id: Company.ID

        ///
        /// Company name.
        ///
        public let name: String

        ///
        /// Company's logo path.
        ///
        /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
        ///
        public let logoPath: URL

        ///
        /// Creates a parent company object.
        ///
        /// - Parameters:
        ///   - id: Company identifier.
        ///   - name: Company name.
        ///   - logoPath: Company's logo path.
        ///
        public init(
            id: Company.ID,
            name: String,
            logoPath: URL
        ) {
            self.id = id
            self.name = name
            self.logoPath = logoPath
        }

    }

}
