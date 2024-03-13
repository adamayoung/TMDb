//
//  AccountServiceWatchlistTests.swift
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

final class AccountServiceWatchlistTests: XCTestCase {

    var service: AccountService!
    var apiClient: MockAPIClient!
    var session: Session!

    override func setUp() {
        super.setUp()
        session = Session(success: true, sessionID: "abc123")
        apiClient = MockAPIClient()
        service = AccountService(apiClient: apiClient)
    }

    override func tearDown() {
        service = nil
        apiClient = nil
        session = nil
        super.tearDown()
    }

}

extension AccountServiceWatchlistTests {

    func testAddMovieToWatchlistReturnsSuccessfully() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        let expectedAddToWatchlist = AddToWatchlistRequestBody(showType: .movie, showID: movieID, isInWatchlist: true)
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))

        try await service.addToWatchlist(movie: movieID, accountID: accountID, session: session)

        XCTAssertEqual(
            apiClient.lastRequestURL,
            AccountEndpoint.addToWatchlist(accountID: accountID, sessionID: session.sessionID).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .post)
        XCTAssertEqual(apiClient.lastRequestBody as? AddToWatchlistRequestBody, expectedAddToWatchlist)
    }

    func testAddMovieToWatchlistWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.addToWatchlist(movie: movieID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
