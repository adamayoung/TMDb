//
//  TMDbAccountServiceWatchlistTests.swift
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

@Suite(.tags(.services, .account))
struct TMDbAccountServiceWatchlistTests {

    var service: TMDbAccountService!
    var apiClient: MockAPIClient!
    var session: Session!

    init() {
        self.session = Session(success: true, sessionID: "abc123")
        self.apiClient = MockAPIClient()
        self.service = TMDbAccountService(apiClient: apiClient)
    }

}

extension TMDbAccountServiceWatchlistTests {

    @Test("movieWatchlist returns movies list")
    func movieWatchlistReturnsMoviesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieWatchlistRequest == expectedRequest)
    }

    @Test("moviesWatchlist when fetching with sortedBy returns movies list")
    func moviesWatchlistWhenFetchingWithSortedByReturnsMoviesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieWatchlistRequest == expectedRequest)
    }

    @Test("moviesWatchlist when fetching with sortedBy and page returns movies list")
    func moviesWatchlistWhenFetchingWithSortedByAndWithPageReturnsMoviesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieWatchlistRequest == expectedRequest)
    }

    @Test("moviesWatchlist when fetching by page returns movies list")
    func moviesWatchlistWhenFetchingByPageReturnsMoviesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieWatchlistRequest == expectedRequest)
    }

    @Test("movingWatchlist when error throws error")
    func moviesWatchlistWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movieWatchlist(accountID: accountID, session: session)
        }
    }

    @Test("addToWatchlist when adding movie to watchlist returns successfully")
    func addMovieToWatchlistReturnsSuccessfully() async throws {
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

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    @Test("addToWatchlist when adding movie errors throws error")
    func addMovieToWatchlistWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addToWatchlist(movie: movieID, accountID: accountID, session: session)
        }
    }

    @Test("removeFromWatchlist when removing movie from watchlist returns successfully")
    func removeMovieFromWatchlistReturnsSuccessfully() async throws {
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

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    @Test("removeFromWatchlist when removing movie errors throws error")
    func removeFavouriteTVSeriesWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.removeFromWatchlist(movie: movieID, accountID: accountID, session: session)
        }
    }

}

extension TMDbAccountServiceWatchlistTests {

    @Test("TV series watchlist returns TV series list")
    func tvSeriesWatchlistReturnsTVSeriesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesWatchlistRequest == expectedRequest)
    }

    @Test("TV series watchlist when fetching with sorted by returns TV series list")
    func tvSeriesWatchlistWhenFetchingWithSortedByReturnsTVSeriesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesWatchlistRequest == expectedRequest)
    }

    @Test("tvSeriesWatchlist when fetching with sorted by and page returns TV series list")
    func tvSeriesWatchlistWhenFetchingWithSortedByAndWithPageReturnsTVSeriesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesWatchlistRequest == expectedRequest)
    }

    @Test("tvSeriesWatchlist when fetching by page returns TV series list")
    func tvSeriesWatchlistWhenFetchingByPageReturnsTVSeriesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesWatchlistRequest == expectedRequest)
    }

    @Test("tvSeriesWatchlist when error throws error")
    func tvSeriesWatchlistWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeriesWatchlist(accountID: accountID, session: session)
        }
    }

    @Test("addToWatchlist when adding TV series to watchlist returns successfully")
    func addTVSeriesToWatchlistReturnsSuccessfully() async throws {
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

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    @Test("addToWatchlist when adding TV series to watchlist errors throws error")
    func addTVSeriesToWatchlistWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addToWatchlist(tvSeries: tvSeriesID, accountID: accountID, session: session)
        }
    }

    @Test("removeFromWatchlist when removing TV series from watchlist returns successfully")
    func removeTVSeriesFromWatchlistReturnsSuccessfully() async throws {
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

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    @Test("removeFromWatchlist when removing TV series from watchlist errors throws error")
    func removeTVSeriesFromWatchlistWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.removeFromWatchlist(tvSeries: tvSeriesID, accountID: accountID, session: session)
        }
    }

}
