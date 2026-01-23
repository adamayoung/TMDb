//
//  AccountDetails+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
