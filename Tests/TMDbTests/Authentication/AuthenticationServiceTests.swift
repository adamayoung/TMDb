//
//  AuthenticationServiceTests.swift
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

final class AuthenticationServiceTests: XCTestCase {

    var service: AuthenticationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = AuthenticationService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testCreateGuestSessionReturnsGuestSession() async throws {
        let expectedResult = GuestSession.mock(expiresAt: Date(timeIntervalSince1970: 1_705_956_596))

        apiClient.result = .success(expectedResult)

        let result = try await service.createGuestSession()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, AuthenticationEndpoint.createGuestSession.path)
    }

    func testCreateGuestSessionWhenErrorsThrowsError() async throws {
        apiClient.result = .failure(.unknown)

        var error: Error?
        do {
            _ = try await service.createGuestSession()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
