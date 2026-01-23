//
//  Network.swift
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
/// A model representing a TV network.
///
public struct Network: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Network identifier.
    ///
    public let id: Int

    ///
    /// Network name.
    ///
    public let name: String

    ///
    /// Network logo path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let logoPath: URL?

    ///
    /// Network origin country.
    ///
    public let originCountry: String?

    ///
    /// Network headquarters location.
    ///
    public let headquarters: String?

    ///
    /// Network homepage URL.
    ///
    public let homepage: URL?

    ///
    /// Creates a network object.
    ///
    /// - Parameters:
    ///    - id: Network identifier.
    ///    - name: Network name.
    ///    - logoPath: Network logo path.
    ///    - originCountry: Network origin country.
    ///    - headquarters: Network headquarters location.
    ///    - homepage: Network homepage URL.
    ///
    public init(
        id: Int,
        name: String,
        logoPath: URL? = nil,
        originCountry: String? = nil,
        headquarters: String? = nil,
        homepage: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
        self.headquarters = headquarters
        self.homepage = homepage
    }

}
