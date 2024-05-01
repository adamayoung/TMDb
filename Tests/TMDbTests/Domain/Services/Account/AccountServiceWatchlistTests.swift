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

    func testMovieWatchlistReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchlistRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.movieWatchlist(accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieWatchlistRequest, expectedRequest)
    }

    func testMoviesWatchlistWhenFetchingWithSortedByReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchlistRequest(
            sortedBy: sortedBy,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.movieWatchlist(sortedBy: sortedBy, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieWatchlistRequest, expectedRequest)
    }

    func testMoviesWatchlistWhenFetchingWithSortedByAndWithPageReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let page = 2
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchlistRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.movieWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieWatchlistRequest, expectedRequest)
    }

    func testMoviesWatchlistWhenFetchingByPageReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchlistRequest(
            sortedBy: nil,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.movieWatchlist(page: page, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieWatchlistRequest, expectedRequest)
    }

    func testMoviesWatchlistWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.movieWatchlist(accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testAddMovieToWatchlistReturnsSuccessfully() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddToWatchlistRequest(
            showType: .movie,
            showID: movieID,
            isInWatchlist: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addToWatchlist(movie: movieID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddToWatchlistRequest, expectedRequest)
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

    func testRemoveMovieFromWatchlistReturnsSuccessfully() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddToWatchlistRequest(
            showType: .movie,
            showID: movieID,
            isInWatchlist: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFromWatchlist(movie: movieID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddToWatchlistRequest, expectedRequest)
    }

    func testRemoveFavouriteTVSeriesWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.removeFromWatchlist(movie: movieID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}

extension AccountServiceWatchlistTests {

    func testTVSeriesWatchlistReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesWatchlistRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.tvSeriesWatchlist(accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesWatchlistRequest, expectedRequest)
    }

    func testTVSeriesWatchlistWhenFetchingWithSortedByReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesWatchlistRequest(
            sortedBy: sortedBy,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.tvSeriesWatchlist(sortedBy: sortedBy, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesWatchlistRequest, expectedRequest)
    }

    func testTVSeriesWatchlistWhenFetchingWithSortedByAndWithPageReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = WatchlistSort.createdAt()
        let page = 2
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesWatchlistRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.tvSeriesWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesWatchlistRequest, expectedRequest)
    }

    func testTVSeriesWatchlistWhenFetchingByPageReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesWatchlistRequest(
            sortedBy: nil,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.tvSeriesWatchlist(page: page, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesWatchlistRequest, expectedRequest)
    }

    func testFavouriteTVSeriesWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.tvSeriesWatchlist(accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testAddTVSeriesToWatchlistReturnsSuccessfully() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: tvSeriesID,
            isInWatchlist: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addToWatchlist(tvSeries: tvSeriesID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddToWatchlistRequest, expectedRequest)
    }

    func testAddTVSeriesToWatchlistWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.addToWatchlist(tvSeries: tvSeriesID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testRemoveTVSeriesFromWatchlistReturnsSuccessfully() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: tvSeriesID,
            isInWatchlist: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFromWatchlist(tvSeries: tvSeriesID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddToWatchlistRequest, expectedRequest)
    }

    func testRemoveTVSeriesFromWatchlistWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            try await service.removeFromWatchlist(tvSeries: tvSeriesID, accountID: accountID, session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
