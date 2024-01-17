//
//  ImagesConfiguration.swift
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
/// A model representing images configuration, which holds data relevant to building image URLs.
///
/// To build an image URL, you will need 3 pieces of data. The `base_url`, `size` and `file_path`. Simply combine them
/// all and you will have a fully qualified URL.
///
/// See <doc:/GeneratingImageURLs> for more details.
///
public struct ImagesConfiguration: Codable, Equatable, Hashable {

    ///
    /// Base image URL (http).
    ///
    public let baseURL: URL

    ///
    /// Base Image secure URL (https).
    ///
    public let secureBaseURL: URL

    ///
    /// Backdrop image sizes.
    ///
    public let backdropSizes: [String]

    ///
    /// Logo image sizes.
    ///
    public let logoSizes: [String]

    ///
    /// Poster image sizes.
    ///
    public let posterSizes: [String]

    ///
    /// Profile image sizes.
    ///
    public let profileSizes: [String]

    ///
    /// Still image sizes.
    ///
    public let stillSizes: [String]

    ///
    /// Creates an images configuration object.
    ///
    /// - Parameters:
    ///    - baseURL: Base image URL (http).
    ///    - secureBaseURL: Base Image secure URL (https).
    ///    - backdropSizes: Backdrop image sizes.
    ///    - logoSizes: Logo image sizes.
    ///    - posterSizes: Poster image sizes.
    ///    - profileSizes: Profile image sizes.
    ///    - stillSizes: Still image sizes.
    ///
    public init(
        baseURL: URL,
        secureBaseURL: URL,
        backdropSizes: [String],
        logoSizes: [String],
        posterSizes: [String],
        profileSizes: [String],
        stillSizes: [String]
    ) {
        self.baseURL = baseURL
        self.secureBaseURL = secureBaseURL
        self.backdropSizes = backdropSizes
        self.logoSizes = logoSizes
        self.posterSizes = posterSizes
        self.profileSizes = profileSizes
        self.stillSizes = stillSizes
    }

}

extension ImagesConfiguration {

    private enum CodingKeys: String, CodingKey {
        case baseURL = "baseUrl"
        case secureBaseURL = "secureBaseUrl"
        case backdropSizes
        case logoSizes
        case posterSizes
        case profileSizes
        case stillSizes
    }

}
