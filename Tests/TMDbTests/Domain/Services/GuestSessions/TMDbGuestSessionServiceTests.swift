//
//  TMDbGuestSessionServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .guestSession))
struct TMDbGuestSessionServiceTests {

    var service: TMDbGuestSessionService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbGuestSessionService(
            apiClient: apiClient
        )
    }

    @Test("ratedMovies returns movie pageable list")
    func ratedMoviesReturnsMoviePageableList() async throws {
        let guestSessionID = "abc123"
        let expectedResult = MoviePageableList.mock()
        let expectedRequest =
            GuestSessionRatedMoviesRequest(
                guestSessionID: guestSessionID
            )

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.ratedMovies(
            sortedBy: nil,
            page: nil,
            guestSessionID: guestSessionID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? GuestSessionRatedMoviesRequest
                == expectedRequest
        )
    }

    @Test("ratedMovies when errors throws error")
    func ratedMoviesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.ratedMovies(
                sortedBy: nil,
                page: nil,
                guestSessionID: "abc123"
            )
        }
    }

    @Test("ratedTVSeries returns TV series pageable list")
    func ratedTVSeriesReturnsTVSeriesPageableList()
    async throws {
        let guestSessionID = "abc123"
        let expectedResult = TVSeriesPageableList.mock()
        let expectedRequest =
            GuestSessionRatedTVSeriesRequest(
                guestSessionID: guestSessionID
            )

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.ratedTVSeries(
            sortedBy: nil,
            page: nil,
            guestSessionID: guestSessionID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? GuestSessionRatedTVSeriesRequest
                == expectedRequest
        )
    }

    @Test("ratedTVSeries when errors throws error")
    func ratedTVSeriesWhenErrorsThrowsError()
    async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.ratedTVSeries(
                sortedBy: nil,
                page: nil,
                guestSessionID: "abc123"
            )
        }
    }

    @Test(
        "ratedTVEpisodes returns TV episode pageable list"
    )
    func ratedTVEpisodesReturnsTVEpisodePageableList()
    async throws {
        let guestSessionID = "abc123"
        let expectedResult = TVEpisodePageableList.mock()
        let expectedRequest =
            GuestSessionRatedTVEpisodesRequest(
                guestSessionID: guestSessionID
            )

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.ratedTVEpisodes(
            sortedBy: nil,
            page: nil,
            guestSessionID: guestSessionID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? GuestSessionRatedTVEpisodesRequest
                == expectedRequest
        )
    }

    @Test("ratedTVEpisodes when errors throws error")
    func ratedTVEpisodesWhenErrorsThrowsError()
    async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.ratedTVEpisodes(
                sortedBy: nil,
                page: nil,
                guestSessionID: "abc123"
            )
        }
    }

}
