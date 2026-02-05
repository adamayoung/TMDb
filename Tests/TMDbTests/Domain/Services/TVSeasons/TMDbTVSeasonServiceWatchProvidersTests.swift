//
//  TMDbTVSeasonServiceWatchProvidersTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeason))
struct TMDbTVSeasonServiceWatchProvidersTests {

    var service: TMDbTVSeasonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeasonService(apiClient: apiClient)
    }

    @Test("watchProviders returns watch providers")
    func watchProvidersReturnsWatchProviders() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1
        let regionCode = "GB"
        let mockResult = ShowWatchProviderResult.mock(
            regionCode: regionCode
        )
        apiClient.addResponse(.success(mockResult))
        let expectedRequest = TVSeasonWatchProvidersRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let result = try await service.watchProviders(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(!result.isEmpty)
        #expect(result.first?.countryCode == regionCode)
        #expect(
            apiClient.lastRequest
                as? TVSeasonWatchProvidersRequest
                == expectedRequest
        )
    }

    @Test("watchProviders when errors throws error")
    func watchProvidersWhenErrorsThrowsError() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.watchProviders(
                forSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

}
