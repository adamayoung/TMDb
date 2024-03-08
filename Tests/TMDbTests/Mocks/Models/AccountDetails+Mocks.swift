//
//  File.swift
//  
//
//  Created by Adam Young on 08/03/2024.
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
