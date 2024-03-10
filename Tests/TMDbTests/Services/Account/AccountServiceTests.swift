//
//  AccountServiceTests.swift
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

final class AccountServiceTests: XCTestCase {

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

    func testDetailsReturnsAccountDetails() async throws {
        let expectedResult = AccountDetails.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, AccountEndpoint.details(sessionID: session.sessionID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testDetailsWhenErrorThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.details(session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testAddFavouriteMovieReturnsSuccessfully() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        let expectedAddFavourite = AddFavouriteRequestBody(showType: .movie, showID: movieID, isFavourite: true)
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))

        try await service.addFavourite(movie: movieID, accountID: accountID, session: session)

        XCTAssertEqual(
            apiClient.lastRequestURL,
            AccountEndpoint.addFavourite(accountID: accountID, sessionID: session.sessionID).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .post)
        XCTAssertEqual(apiClient.lastRequestBody as? AddFavouriteRequestBody, expectedAddFavourite)
    }

    func testAddFavouriteMovieWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.addFavourite(movie: movieID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testRemoveFavouriteMovieReturnsSuccessfully() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        let expectedAddFavourite = AddFavouriteRequestBody(showType: .movie, showID: movieID, isFavourite: false)
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))

        try await service.removeFavourite(movie: movieID, accountID: accountID, session: session)

        XCTAssertEqual(
            apiClient.lastRequestURL,
            AccountEndpoint.addFavourite(accountID: accountID, sessionID: session.sessionID).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .post)
        XCTAssertEqual(apiClient.lastRequestBody as? AddFavouriteRequestBody, expectedAddFavourite)
    }

    func testRemoveFavouriteMovieWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.removeFavourite(movie: movieID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testAddFavouriteTVSeriesReturnsSuccessfully() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        let expectedAddFavourite = AddFavouriteRequestBody(showType: .tvSeries, showID: tvSeriesID, isFavourite: true)
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))

        try await service.addFavourite(tvSeries: tvSeriesID, accountID: accountID, session: session)

        XCTAssertEqual(
            apiClient.lastRequestURL,
            AccountEndpoint.addFavourite(accountID: accountID, sessionID: session.sessionID).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .post)
        XCTAssertEqual(apiClient.lastRequestBody as? AddFavouriteRequestBody, expectedAddFavourite)
    }

    func testAddFavouriteTVSeriesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.addFavourite(tvSeries: tvSeriesID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testRemoveFavouriteTVSeriesReturnsSuccessfully() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        let expectedAddFavourite = AddFavouriteRequestBody(showType: .tvSeries, showID: tvSeriesID, isFavourite: false)
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))

        try await service.removeFavourite(tvSeries: tvSeriesID, accountID: accountID, session: session)

        XCTAssertEqual(
            apiClient.lastRequestURL,
            AccountEndpoint.addFavourite(accountID: accountID, sessionID: session.sessionID).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .post)
        XCTAssertEqual(apiClient.lastRequestBody as? AddFavouriteRequestBody, expectedAddFavourite)
    }

    func testRemoveFavouriteTVSeriesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.removeFavourite(tvSeries: tvSeriesID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
