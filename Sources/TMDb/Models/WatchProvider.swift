//
//  WatchProvider.swift
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
/// A model representing a watch provider.
///
public struct WatchProvider: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Watch Provider identifier.
    ///
    public let id: Int

    ///
    /// Watch Provider Name.
    ///
    public let name: String

    ///
    /// Watch Provider logo path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let logoPath: URL

    ///
    /// Creates a watch provider object.
    ///
    /// - Parameters:
    ///    - id: Watch Provider identifier.
    ///    - name: Watch Provider name.
    ///    - logoPath: Watch Provider logo path.
    ///
    public init(id: Int, name: String, logoPath: URL) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
    }

}

extension WatchProvider {

    private enum CodingKeys: String, CodingKey {
        case id = "providerId"
        case name = "providerName"
        case logoPath

    }

}
