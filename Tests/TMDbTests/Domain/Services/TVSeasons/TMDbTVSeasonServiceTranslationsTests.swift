//
//  TMDbTVSeasonServiceTranslationsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeason))
struct TMDbTVSeasonServiceTranslationsTests {

    var service: TMDbTVSeasonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeasonService(apiClient: apiClient)
    }

    @Test("translations returns translations")
    func translationsReturnsTranslations() async throws {
        let expectedResult =
            TranslationCollection<TVSeasonTranslationData>.mock()
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonTranslationsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let result = try await service.translations(
            forSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVSeasonTranslationsRequest
                == expectedRequest
        )
    }

    @Test("translations when errors throws error")
    func translationsWhenErrorsThrowsError() async throws {
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.translations(
                forSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

}
