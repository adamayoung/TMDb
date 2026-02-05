//
//  TMDbTVSeasonServiceChangesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeason))
struct TMDbTVSeasonServiceChangesTests {

    var service: TMDbTVSeasonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeasonService(apiClient: apiClient)
    }

    @Test("changes returns changes")
    func changesReturnsChanges() async throws {
        let expectedResult = ChangeCollection.mock()
        let seasonID = 3625
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonChangesRequest(
            seasonID: seasonID
        )

        let result = try await service.changes(
            forSeason: seasonID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVSeasonChangesRequest
                == expectedRequest
        )
    }

    @Test("changes when errors throws error")
    func changesWhenErrorsThrowsError() async throws {
        let seasonID = 3625
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.changes(forSeason: seasonID)
        }
    }

}
