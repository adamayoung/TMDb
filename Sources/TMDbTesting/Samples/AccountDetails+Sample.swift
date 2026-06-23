//
//  AccountDetails+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension AccountDetails {

    /// A sample `AccountDetails` populated with representative data.
    static var sample: AccountDetails {
        AccountDetails(
            id: 1,
            username: "test",
            name: "Testy McTestface",
            avatar: AccountAvatar(
                gravatar: AccountAvatar.Gravatar(
                    hash: "qwertyuiopasdfghjklzxcvbnm"
                ),
                tmdb: AccountAvatar.TMDb(
                    avatarPath: "/some/path/image.jpg"
                )
            ),
            languageCode: "en",
            countryCode: "GB",
            includeAdult: false
        )
    }

}
