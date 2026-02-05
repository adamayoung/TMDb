//
//  TMDbTVEpisodeServiceChangesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvEpisode))
struct TMDbTVEpisodeServiceChangesTests {

    var service: TMDbTVEpisodeService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeService(apiClient: apiClient)
    }

    @Test("changes returns changes")
    func changesReturnsChanges() async throws {
        let expectedResult = ChangeCollection.mock()
        let episodeID = 63066
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVEpisodeChangesRequest(
            episodeID: episodeID
        )

        let result = try await service.changes(
            forEpisode: episodeID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVEpisodeChangesRequest
                == expectedRequest
        )
    }

    @Test("changes when errors throws error")
    func changesWhenErrorsThrowsError() async throws {
        let episodeID = 63066
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.changes(forEpisode: episodeID)
        }
    }

}
