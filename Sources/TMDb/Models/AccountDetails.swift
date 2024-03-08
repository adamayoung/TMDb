//
//  AccountDetails.swift
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
/// A model representing a TMDb user's account details.
///
public struct AccountDetails: Identifiable, Codable, Equatable, Hashable {

    ///
    /// User identifier.
    ///
    public let id: Int

    ///
    /// Username.
    ///
    public let username: String

    ///
    /// User's name.
    ///
    public let name: String

    ///
    /// User's avatars.
    ///
    public let avatar: AccountAvatar

    ///
    /// User's language.
    ///
    public let languageCode: String

    ///
    /// User's country.
    ///
    public let countryCode: String

    ///
    /// Whether or not the user wants to include adult content in results.
    ///
    public let includeAdult: Bool

    ///
    /// Creates an account details object.
    ///
    /// - Parameters:
    ///   - id: User identifier.
    ///   - username: Username.
    ///   - name: User's name.
    ///   - avatar: User's avatars.
    ///   - languageCode: User's language.
    ///   - countryCode: User's country.
    ///   - includeAdult: Whether or not the user wants to include adult content in results.
    ///
    public init(
        id: Int,
        username: String,
        name: String,
        avatar: AccountAvatar,
        languageCode: String,
        countryCode: String,
        includeAdult: Bool
    ) {
        self.id = id
        self.username = username
        self.name = name
        self.avatar = avatar
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.includeAdult = includeAdult
    }

}

extension AccountDetails {

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case avatar
        case languageCode = "iso6391"
        case countryCode = "iso31661"
        case includeAdult
    }

}
