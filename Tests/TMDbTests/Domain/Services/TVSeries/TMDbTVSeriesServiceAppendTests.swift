//
//  TMDbTVSeriesServiceAppendTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceAppendTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("details with append returns response")
    func detailsWithAppendReturnsResponse() async throws {
        let expectedResult = TVSeriesDetailsResponse(
            tvSeries: .theSandman
        )
        let tvSeriesID = expectedResult.tvSeries.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesDetailsAppendRequest(
            id: tvSeriesID,
            appendToResponse: [.credits, .images],
            language: nil
        )

        let result = try await (service as TVSeriesService).details(
            forTVSeries: tvSeriesID,
            appending: [.credits, .images]
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVSeriesDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append and language returns response")
    func detailsWithAppendAndLanguageReturnsResponse() async throws {
        let expectedResult = TVSeriesDetailsResponse(
            tvSeries: .theSandman
        )
        let tvSeriesID = expectedResult.tvSeries.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesDetailsAppendRequest(
            id: tvSeriesID,
            appendToResponse: .credits,
            language: language
        )

        let result = try await service.details(
            forTVSeries: tvSeriesID,
            appending: .credits,
            language: language
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVSeriesDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append when errors throws error")
    func detailsWithAppendWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forTVSeries: tvSeriesID,
                appending: .credits
            )
        }
    }

}
