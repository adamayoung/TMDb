//
//  TMDbTVSeriesServiceScreenedTheatricallyTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceScreenedTheatricallyTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("screenedTheatrically returns screened theatrically collection")
    func screenedTheatricallyReturnsCollection() async throws {
        let expectedResult = ScreenedTheatricallyCollection.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesScreenedTheatricallyRequest(id: tvSeriesID)

        let result = try await service.screenedTheatrically(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? TVSeriesScreenedTheatricallyRequest == expectedRequest
        )
    }

    @Test("screenedTheatrically when errors throws error")
    func screenedTheatricallyWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.screenedTheatrically(forTVSeries: tvSeriesID)
        }
    }

    @Test("JSON decoding of ScreenedTheatricallyCollection", .tags(.decoding))
    func decodeScreenedTheatricallyCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ScreenedTheatricallyCollection.self,
            fromResource: "tv-series-screened-theatrically"
        )

        #expect(result.id == 1399)
        #expect(result.results.count == 5)
        #expect(result.results[0].id == 62085)
        #expect(result.results[0].episodeNumber == 1)
        #expect(result.results[0].seasonNumber == 1)
    }

}
