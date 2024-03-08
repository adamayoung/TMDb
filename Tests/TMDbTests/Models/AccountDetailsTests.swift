//
//  AccountDetailsTests.swift
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

@testable import TMDb
import XCTest

final class AccountDetailsTests: XCTestCase {

    func testDecodeReturnsAccountDetails() throws {
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

        let result = try JSONDecoder.theMovieDatabase.decode(AccountDetails.self, fromResource: "account-details")

        XCTAssertEqual(result.id, accountDetails.id)
    }

}
