//
//  TMDbTVEpisodeGroupServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvEpisodeGroup))
struct TMDbTVEpisodeGroupServiceTests {

    var service: TMDbTVEpisodeGroupService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVEpisodeGroupService(
            apiClient: apiClient
        )
    }

    @Test("details returns TV episode group")
    func detailsReturnsTVEpisodeGroup() async throws {
        let expectedResult = TVEpisodeGroup.mock()
        let groupID = expectedResult.id
        let expectedRequest = TVEpisodeGroupRequest(
            id: groupID
        )

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(
            forTVEpisodeGroup: groupID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest
                as? TVEpisodeGroupRequest
                == expectedRequest
        )
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let groupID = "invalid"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forTVEpisodeGroup: groupID
            )
        }
    }

    @Test("details with empty ID throws bad request and performs no request")
    func detailsWithEmptyIDThrowsBadRequest() async throws {
        await #expect(throws: TMDbError
            .badRequest(TMDbErrorContext(statusMessage: "TV episode group ID must not be empty"))) {
            _ = try await service.details(forTVEpisodeGroup: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("details with whitespace ID throws bad request and performs no request")
    func detailsWithWhitespaceIDThrowsBadRequest() async throws {
        await #expect(throws: TMDbError
            .badRequest(TMDbErrorContext(statusMessage: "TV episode group ID must not be empty"))) {
            _ = try await service.details(forTVEpisodeGroup: "  \n ")
        }

        #expect(apiClient.requests.isEmpty)
    }

}
