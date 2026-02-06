//
//  TMDbTVSeasonServiceAppendTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeason))
struct TMDbTVSeasonServiceAppendTests {

    var service: TMDbTVSeasonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeasonService(apiClient: apiClient)
    }

    @Test("details with append returns response")
    func detailsWithAppendReturnsResponse() async throws {
        let expectedResult = TVSeasonDetailsResponse(
            season: .mock()
        )
        let tvSeriesID = 1
        let seasonNumber = expectedResult.season.seasonNumber
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonDetailsAppendRequest(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            appendToResponse: [.credits, .images],
            language: nil
        )

        let result = try await (service as TVSeasonService).details(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            appending: [.credits, .images]
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVSeasonDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append and language returns response")
    func detailsWithAppendAndLanguageReturnsResponse() async throws {
        let expectedResult = TVSeasonDetailsResponse(
            season: .mock()
        )
        let tvSeriesID = 1
        let seasonNumber = expectedResult.season.seasonNumber
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonDetailsAppendRequest(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            appendToResponse: .credits,
            language: language
        )

        let result = try await service.details(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID,
            appending: .credits,
            language: language
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVSeasonDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append when errors throws error")
    func detailsWithAppendWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        let seasonNumber = 2
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                appending: .credits
            )
        }
    }

}
