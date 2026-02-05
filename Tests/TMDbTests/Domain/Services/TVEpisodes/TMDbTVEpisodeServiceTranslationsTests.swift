//
//  TMDbTVEpisodeServiceTranslationsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvEpisode))
struct TMDbTVEpisodeServiceTranslationsTests {

    var service: TMDbTVEpisodeService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeService(apiClient: apiClient)
    }

    @Test("translations returns translations")
    func translationsReturnsTranslations() async throws {
        let expectedResult =
            TranslationCollection<TVEpisodeTranslationData>
                .mock()
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeTranslationsRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let result = try await service.translations(
            forEpisode: episodeNumber,
            inSeason: seasonNumber,
            inTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVEpisodeTranslationsRequest
                == expectedRequest
        )
    }

    @Test("translations when errors throws error")
    func translationsWhenErrorsThrowsError() async throws {
        let episodeNumber = 1
        let seasonNumber = 2
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.translations(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
        }
    }

}
