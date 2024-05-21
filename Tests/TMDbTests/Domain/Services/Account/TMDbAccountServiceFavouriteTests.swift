//
//  TMDbAccountServiceFavouriteTests.swift
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

final class TMDbAccountFavouriteServiceTests: XCTestCase {

    var service: TMDbAccountService!
    var apiClient: MockAPIClient!
    var session: Session!

    override func setUp() {
        super.setUp()
        session = Session(success: true, sessionID: "abc123")
        apiClient = MockAPIClient()
        service = TMDbAccountService(apiClient: apiClient)
    }

    override func tearDown() {
        service = nil
        apiClient = nil
        session = nil
        super.tearDown()
    }

}

extension TMDbAccountFavouriteServiceTests {

    func testFavouriteMoviesReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteMoviesRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteMovies(accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteMoviesRequest, expectedRequest)
    }

    func testFavouriteMoviesWhenFetchingWithSortedByReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteMoviesRequest(
            sortedBy: sortedBy,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteMovies(sortedBy: sortedBy, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteMoviesRequest, expectedRequest)
    }

    func testFavouriteMoviesWhenFetchingWithSortedByAndWithPageReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let page = 2
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteMovies(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteMoviesRequest, expectedRequest)
    }

    func testFavouriteMoviesWhenFetchingByPageReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteMoviesRequest(
            sortedBy: nil,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteMovies(page: page, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteMoviesRequest, expectedRequest)
    }

    func testFavouriteMoviesWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.favouriteMovies(accountID: accountID, session: session)
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
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddFavouriteRequest(
            showType: .movie,
            showID: movieID,
            isFavourite: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addFavourite(movie: movieID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddFavouriteRequest, expectedRequest)
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
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddFavouriteRequest(
            showType: .movie,
            showID: movieID,
            isFavourite: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFavourite(movie: movieID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddFavouriteRequest, expectedRequest)
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

}

extension TMDbAccountFavouriteServiceTests {

    func testFavouriteTVSeriesReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteTVSeriesRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteTVSeries(accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteTVSeriesRequest, expectedRequest)
    }

    func testFavouriteTVSeriesWhenFetchingWithSortedByReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteTVSeriesRequest(
            sortedBy: sortedBy,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteTVSeries(sortedBy: sortedBy, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteTVSeriesRequest, expectedRequest)
    }

    func testFavouriteTVSeriesWhenFetchingWithSortedByAndWithPageReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = FavouriteSort.createdAt()
        let page = 2
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteTVSeries(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteTVSeriesRequest, expectedRequest)
    }

    func testFavouriteTVSeriesWhenFetchingByPageReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteTVSeriesRequest(
            sortedBy: nil,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteTVSeries(page: page, accountID: accountID, session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? FavouriteTVSeriesRequest, expectedRequest)
    }

    func testFavouriteTVSeriesWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.favouriteTVSeries(accountID: accountID, session: session)
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
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddFavouriteRequest(
            showType: .tvSeries,
            showID: tvSeriesID,
            isFavourite: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addFavourite(tvSeries: tvSeriesID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddFavouriteRequest, expectedRequest)
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
        let responseResult = SuccessResult(success: true)
        apiClient.addResponse(.success(responseResult))
        let expectedRequest = AddFavouriteRequest(
            showType: .tvSeries,
            showID: tvSeriesID,
            isFavourite: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFavourite(tvSeries: tvSeriesID, accountID: accountID, session: session)

        XCTAssertEqual(apiClient.lastRequest as? AddFavouriteRequest, expectedRequest)
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
