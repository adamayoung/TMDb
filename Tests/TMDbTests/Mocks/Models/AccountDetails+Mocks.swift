//
//  AccountDetails+Mocks.swift
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
import TMDb

extension AccountDetails {

    static func mock(
        id: Int = 1,
        username: String = "test",
        name: String = "Testy McTestface",
        avatar: AccountAvatar = AccountAvatar(
            gravatar: AccountAvatar.Gravatar(
                hash: "qwertyuiopasdfghjklzxcvbnm"
            ),
            tmdb: AccountAvatar.TMDb(
                avatarPath: "/some/path/image.jpg"
            )
        ),
        languageCode: String = "en",
        countryCode: String = "GB",
        includeAdult: Bool = false
    ) -> AccountDetails {
        AccountDetails(
            id: id,
            username: username,
            name: name,
            avatar: avatar,
            languageCode: languageCode,
            countryCode: countryCode,
            includeAdult: includeAdult
        )
    }

}
