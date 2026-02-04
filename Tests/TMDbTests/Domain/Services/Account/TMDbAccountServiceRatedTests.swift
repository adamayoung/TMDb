//
//  TMDbAccountServiceRatedTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .account))
struct TMDbAccountServiceRatedTests {

    var service: TMDbAccountService!
    var apiClient: MockAPIClient!
    var session: Session!

    init() {
        self.session = Session(success: true, sessionID: "abc123")
        self.apiClient = MockAPIClient()
        self.service = TMDbAccountService(apiClient: apiClient)
    }

}

extension TMDbAccountServiceRatedTests {

    @Test("ratedMovies with default parameter values returns movies list")
    func ratedMoviesWithDefaultParameterValuesReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedMoviesRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await (service as AccountService).ratedMovies(
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedMoviesRequest == expectedRequest)
    }

    @Test("ratedMovies when fetching with sorted by returns movies list")
    func ratedMoviesWhenFetchingWithSortedByReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = RatedSort.createdAt()
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedMoviesRequest(
            sortedBy: sortedBy,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedMovies(
            sortedBy: sortedBy, accountID: accountID, session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedMoviesRequest == expectedRequest)
    }

    @Test("ratedMovies when fetching with sorted by and with page returns movies list")
    func ratedMoviesWhenFetchingWithSortedByAndWithPageReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = RatedSort.createdAt()
        let page = 2
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedMovies(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedMoviesRequest == expectedRequest)
    }

    @Test("ratedMovies when fetching by page returns movies list")
    func ratedMoviesWhenFetchingByPageReturnsMoviesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedMoviesRequest(
            sortedBy: nil,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedMovies(
            page: page,
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedMoviesRequest == expectedRequest)
    }

    @Test("ratedTVSeries with default parameter values returns TV series list")
    func ratedTVSeriesWithDefaultParameterValuesReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVSeriesRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await (service as AccountService).ratedTVSeries(
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVSeriesRequest == expectedRequest)
    }

    @Test("ratedTVSeries when fetching with sorted by returns TV series list")
    func ratedTVSeriesWhenFetchingWithSortedByReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = RatedSort.createdAt()
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVSeriesRequest(
            sortedBy: sortedBy,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedTVSeries(
            sortedBy: sortedBy, accountID: accountID, session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVSeriesRequest == expectedRequest)
    }

    @Test("ratedTVSeries when fetching with sorted by and with page returns TV series list")
    func ratedTVSeriesWhenFetchingWithSortedByAndWithPageReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = RatedSort.createdAt()
        let page = 2
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedTVSeries(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVSeriesRequest == expectedRequest)
    }

    @Test("ratedTVSeries when fetching by page returns TV series list")
    func ratedTVSeriesWhenFetchingByPageReturnsTVSeriesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVSeriesRequest(
            sortedBy: nil,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedTVSeries(
            page: page,
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVSeriesRequest == expectedRequest)
    }

    @Test("ratedTVEpisodes with default parameter values returns TV episodes list")
    func ratedTVEpisodesWithDefaultParameterValuesReturnsTVEpisodesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = TVEpisodePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVEpisodesRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await (service as AccountService).ratedTVEpisodes(
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVEpisodesRequest == expectedRequest)
    }

    @Test("ratedTVEpisodes when fetching with sorted by returns TV episodes list")
    func ratedTVEpisodesWhenFetchingWithSortedByReturnsTVEpisodesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = RatedSort.createdAt()
        let expectedResult = TVEpisodePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVEpisodesRequest(
            sortedBy: sortedBy,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedTVEpisodes(
            sortedBy: sortedBy, accountID: accountID, session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVEpisodesRequest == expectedRequest)
    }

    @Test("ratedTVEpisodes when fetching with sorted by and with page returns TV episodes list")
    func ratedTVEpisodesWhenFetchingWithSortedByAndWithPageReturnsTVEpisodesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let sortedBy = RatedSort.createdAt()
        let page = 2
        let expectedResult = TVEpisodePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVEpisodesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedTVEpisodes(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVEpisodesRequest == expectedRequest)
    }

    @Test("ratedTVEpisodes when fetching by page returns TV episodes list")
    func ratedTVEpisodesWhenFetchingByPageReturnsTVEpisodesList() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = TVEpisodePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedTVEpisodesRequest(
            sortedBy: nil,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedTVEpisodes(
            page: page,
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedTVEpisodesRequest == expectedRequest)
    }

    @Test("lists with default parameter values returns lists")
    func listsWithDefaultParameterValuesReturnsLists() async throws {
        let accountID = 123
        let session = Session.mock()
        let expectedResult = MediaListSummaryPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = AccountListsRequest(
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await (service as AccountService).lists(
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? AccountListsRequest == expectedRequest)
    }

    @Test("lists when fetching by page returns lists")
    func listsWhenFetchingByPageReturnsLists() async throws {
        let accountID = 123
        let session = Session.mock()
        let page = 2
        let expectedResult = MediaListSummaryPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = AccountListsRequest(
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.lists(
            page: page,
            accountID: accountID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? AccountListsRequest == expectedRequest)
    }

}
