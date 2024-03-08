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

public struct AccountDetails: Identifiable, Codable, Equatable, Hashable {

    public let id: Int
    public let username: String
    public let name: String
    public let avatar: AccountAvatar
    public let languageCode: String
    public let countryCode: String
    public let includeAdult: Bool

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
