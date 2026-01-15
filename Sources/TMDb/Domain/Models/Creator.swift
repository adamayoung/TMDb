//
//  Creator.swift
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
/// A model representing a creator of a TV series.
///
public struct Creator: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Creator's identifier.
    ///
    public let id: Int

    ///
    /// Creator's identifier for the particular TV series.
    ///
    public let creditID: String

    ///
    /// Creator's name.
    ///
    public let name: String

    ///
    /// Creator's original name.
    ///
    public let originalName: String

    ///
    /// Creator's gender.
    ///
    public let gender: Gender?

    ///
    /// Creator's profile image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Creates a creator object.
    ///
    /// - Parameters:
    ///    - id: Creator's identifier.
    ///    - creditID: Creator's identifier for the particular TV series.
    ///    - name: Creator's name.
    ///    - originalName: Creator's original name.
    ///    - gender: Creator's gender.
    ///    - profilePath: Creator's profile image.
    ///
    public init(
        id: Int,
        creditID: String,
        name: String,
        originalName: String,
        gender: Gender? = nil,
        profilePath: URL? = nil
    ) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.originalName = originalName
        self.gender = gender
        self.profilePath = profilePath
    }

}

extension Creator {

    private enum CodingKeys: String, CodingKey {
        case id
        case creditID = "creditId"
        case name
        case originalName
        case gender
        case profilePath
    }

}
