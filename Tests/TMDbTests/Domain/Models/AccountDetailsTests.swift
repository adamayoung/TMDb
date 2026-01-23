//
//  AccountDetailsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct AccountDetailsTests {

    @Test("JSON decoding of AccountDetails", .tags(.decoding))
    func decodeAccountDetails() throws {
        let accountDetails = AccountDetails(
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
            includeAdult: false
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            AccountDetails.self, fromResource: "account-details"
        )

        #expect(result.id == accountDetails.id)
    }

}
