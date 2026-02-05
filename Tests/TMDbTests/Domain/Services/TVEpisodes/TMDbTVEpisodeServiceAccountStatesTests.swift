//
//  TMDbTVEpisodeServiceAccountStatesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvEpisode))
struct TMDbTVEpisodeServiceAccountStatesTests {

    var service: TMDbTVEpisodeService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeService(apiClient: apiClient)
    }

    @Test("accountStates returns account states")
    func accountStatesReturnsAccountStates() async throws {
        let expectedResult = AccountStates.mock()
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeAccountStatesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        let result = try await service.accountStates(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            session: session
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVEpisodeAccountStatesRequest
                == expectedRequest
        )
    }

    @Test("accountStates when errors throws error")
    func accountStatesWhenErrorsThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        let session = Session.mock()
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.accountStates(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                session: session
            )
        }
    }

}
