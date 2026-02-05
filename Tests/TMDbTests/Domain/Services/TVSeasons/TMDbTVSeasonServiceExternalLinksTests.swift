//
//  TMDbTVSeasonServiceExternalLinksTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeason))
struct TMDbTVSeasonServiceExternalLinksTests {

    var service: TMDbTVSeasonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeasonService(apiClient: apiClient)
    }

    @Test("externalLinks returns external links")
    func externalLinksReturnsExternalLinks() async throws {
        let expectedResult =
            TVSeasonExternalLinksCollection.mock()
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonExternalLinksRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let result = try await service.externalLinks(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVSeasonExternalLinksRequest
                == expectedRequest
        )
    }

    @Test("externalLinks when errors throws error")
    func externalLinksWhenErrorsThrowsError() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.externalLinks(
                forSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

}
