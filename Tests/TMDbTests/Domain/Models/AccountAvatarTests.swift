//
//  AccountAvatarTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct AccountAvatarTests {

    @Test("JSON decoding of AccountAvatar")
    func decodeReturnsAccountAvatar() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AccountAvatar.self,
            fromResource: "account-avatar"
        )

        #expect(result.gravatar.hash == accountAvatar.gravatar.hash)
        #expect(result.tmdb.avatarPath == accountAvatar.tmdb.avatarPath)
    }

}

extension AccountAvatarTests {

    private var accountAvatar: AccountAvatar {
        AccountAvatar(
            gravatar: AccountAvatar.Gravatar(
                hash: "c9e9fc152ee756a900db85757c29815d"
            ),
            tmdb: AccountAvatar.TMDb(
                avatarPath: "/5pF2ecF4fW9v7cEyxJQh8VkJZyL.jpg"
            )
        )
    }

}
