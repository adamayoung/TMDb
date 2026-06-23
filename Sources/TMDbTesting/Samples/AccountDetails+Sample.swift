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
            id: 548,
            username: "travisbell",
            name: "Travis Bell",
            avatar: AccountAvatar(
                gravatar: AccountAvatar.Gravatar(
                    hash: "c9e9fc152ee756a900db85757c29815d"
                ),
                tmdb: AccountAvatar.TMDb(
                    avatarPath: "/xy44UvpbTgzs9kWmp4C3fEaCl5h.png"
                )
            ),
            languageCode: "en",
            countryCode: "CA",
            includeAdult: true
        )
    }

}
