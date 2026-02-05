//
//  TMDbTVEpisodeServiceExternalLinksTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvEpisode))
struct TMDbTVEpisodeServiceExternalLinksTests {

    var service: TMDbTVEpisodeService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeService(apiClient: apiClient)
    }

    @Test("externalLinks returns external links")
    func externalLinksReturnsExternalLinks() async throws {
        let expectedResult =
            TVEpisodeExternalLinksCollection.mock()
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeExternalLinksRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let result = try await service.externalLinks(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVEpisodeExternalLinksRequest
                == expectedRequest
        )
    }

    @Test("externalLinks when errors throws error")
    func externalLinksWhenErrorsThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.externalLinks(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

}
