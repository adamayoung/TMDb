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

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .account))
struct TMDbAccountFavouriteServiceTests {

    var service: TMDbAccountService!
    var apiClient: MockAPIClient!
    var session: Session!

    init() {
        self.session = Session(success: true, sessionID: "abc123")
        self.apiClient = MockAPIClient()
        self.service = TMDbAccountService(apiClient: apiClient)
    }

}

extension TMDbAccountFavouriteServiceTests {

    @Test("favouriteMovies returns movies list")
    func favouriteMoviesReturnsMoviesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteMoviesRequest == expectedRequest)
    }

    @Test("favouriteMovies when fetching with sorted by returns movies list")
    func favouriteMoviesWhenFetchingWithSortedByReturnsMoviesList() async throws {
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

        let result = try await service.favouriteMovies(
            sortedBy: sortedBy, accountID: accountID, session: session)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteMoviesRequest == expectedRequest)
    }

    @Test("favouriteMovies when fetching with sorted by and with page returns movies list")
    func favouriteMoviesWhenFetchingWithSortedByAndWithPageReturnsMoviesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteMoviesRequest == expectedRequest)
    }

    @Test("favouriteMovies when fetching by page returns movies list")
    func favouriteMoviesWhenFetchingByPageReturnsMoviesList() async throws {
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

        let result = try await service.favouriteMovies(
            page: page, accountID: accountID, session: session)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteMoviesRequest == expectedRequest)
    }

    @Test("favouriteMovies when error throws error")
    func favouriteMoviesWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.favouriteMovies(accountID: accountID, session: session)
        }
    }

    @Test("addFavourite movie returns successfully")
    func addFavouriteMovieReturnsSuccessfully() async throws {
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

        await #expect(throws: Never.self) {
            try await service.addFavourite(movie: movieID, accountID: accountID, session: session)
        }

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    @Test("addFavourite movie when errors throws error")
    func addFavouriteMovieWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.addFavourite(
                movie: movieID, accountID: accountID, session: session)
        }
    }

    @Test("remove favourite movie returns successfully")
    func removeFavouriteMovieReturnsSuccessfully() async throws {
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

        await #expect(throws: Never.self) {
            try await service.removeFavourite(
                movie: movieID, accountID: accountID, session: session)
        }

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    @Test("removeFavourite movie when errors throws error")
    func removeFavouriteMovieWhenErrorsThrowsError() async throws {
        let movieID = 550
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.removeFavourite(
                movie: movieID, accountID: accountID, session: session)
        }
    }

}

extension TMDbAccountFavouriteServiceTests {

    @Test("favouriteTVSeries returns TV series list")
    func favouriteTVSeriesReturnsTVSeriesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteTVSeriesRequest == expectedRequest)
    }

    @Test("favouriteTVSeries when fetching with sortedBy returns TV series list")
    func favouriteTVSeriesWhenFetchingWithSortedByReturnsTVSeriesList() async throws {
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

        let result = try await service.favouriteTVSeries(
            sortedBy: sortedBy, accountID: accountID, session: session)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteTVSeriesRequest == expectedRequest)
    }

    @Test("favouriteTVSeries when fetching with sortedBy and with page returns TV series list")
    func favouriteTVSeriesWhenFetchingWithSortedByAndWithPageReturnsTVSeriesList() async throws {
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

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteTVSeriesRequest == expectedRequest)
    }

    @Test("favouriteTVSeries when fetching by page returns TV series list")
    func favouriteTVSeriesWhenFetchingByPageReturnsTVSeriesList() async throws {
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

        let result = try await service.favouriteTVSeries(
            page: page, accountID: accountID, session: session)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteTVSeriesRequest == expectedRequest)
    }

    @Test("favouriteTVSeries when error throws error")
    func favouriteTVSeriesWhenErrorThrowsError() async throws {
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.favouriteTVSeries(accountID: accountID, session: session)
        }
    }

    @Test("addFavourite TV series returns successfully")
    func addFavouriteTVSeriesReturnsSuccessfully() async throws {
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

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    @Test("addFavourite TV series when errors throws error")
    func addFavouriteTVSeriesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addFavourite(
                tvSeries: tvSeriesID, accountID: accountID, session: session)
        }
    }

    @Test("removeFavourite TV series returns successfully")
    func removeFavouriteTVSeriesReturnsSuccessfully() async throws {
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

        try await service.removeFavourite(
            tvSeries: tvSeriesID, accountID: accountID, session: session)

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    @Test("removeFavourite TV series when errors throws error")
    func removeFavouriteTVSeriesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 101
        let accountID = 123
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.removeFavourite(
                tvSeries: tvSeriesID, accountID: accountID, session: session)
        }
    }

}
