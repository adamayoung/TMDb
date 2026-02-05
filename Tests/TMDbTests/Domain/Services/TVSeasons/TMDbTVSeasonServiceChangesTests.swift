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

    @Test(
        "changes with start date, end date and page returns changes"
    )
    func changesWithStartDateAndEndDateAndPageReturnsChanges()
    async throws {
        let expectedResult = ChangeCollection.mock()
        let seasonID = 3625
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_735_689_600)
        let page = 2
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeasonChangesRequest(
            seasonID: seasonID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let result = try await service.changes(
            forSeason: seasonID,
            startDate: startDate,
            endDate: endDate,
            page: page
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
