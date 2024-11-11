//
//  AuthenticationIntegrationTests.swift
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
import Testing

@testable import TMDb

@Suite(
    .tags(.authentication),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct AuthenticationIntegrationTests {

    var authenticationService: (any AuthenticationService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.authenticationService = TMDbClient(apiKey: apiKey).authentication
    }

    @Test("guestSession")
    func guestSession() async throws {
        let session = try await authenticationService.guestSession()

        #expect(session.success)
        #expect(session.guestSessionID != "")
    }

    @Test("requestToken")
    func requestToken() async throws {
        let token = try await authenticationService.requestToken()

        #expect(token.success)
        #expect(token.requestToken != "")
    }

    @Test(
        "createSession with credential",
        .enabled(if: CredentialHelper.shared.hasCredential),
        .disabled()
    )
    func createAndDeleteSessionWithCredential() async throws {
        let credential = CredentialHelper.shared.tmdbCredential

        let session = try await authenticationService.createSession(withCredential: credential)

        #expect(session.success)
        #expect(session.sessionID != "")

        do {
            let deleteResult = try await authenticationService.deleteSession(session)
            #expect(deleteResult)
        } catch let error {
            print(error)
        }
    }

    @Test("validateKey")
    func validateKeyWhenValid() async throws {
        let isValid = try await authenticationService.validateKey()

        #expect(isValid)
    }

}
