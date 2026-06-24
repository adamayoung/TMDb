//
//  TMDbReviewServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .review))
struct TMDbReviewServiceTests {

    var service: TMDbReviewService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbReviewService(
            apiClient: apiClient
        )
    }

    @Test("details returns review")
    func detailsReturnsReview() async throws {
        let expectedResult = Review.mock()
        let reviewID = expectedResult.id
        let expectedRequest = ReviewRequest(id: reviewID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(
            forReview: reviewID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? ReviewRequest
                == expectedRequest
        )
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let reviewID = "invalid"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forReview: reviewID
            )
        }
    }

    @Test("details with empty ID throws bad request and performs no request")
    func detailsWithEmptyIDThrowsBadRequest() async throws {
        await #expect(throws: TMDbError.badRequest("Review ID must not be empty")) {
            _ = try await service.details(forReview: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("details with whitespace ID throws bad request and performs no request")
    func detailsWithWhitespaceIDThrowsBadRequest() async throws {
        await #expect(throws: TMDbError.badRequest("Review ID must not be empty")) {
            _ = try await service.details(forReview: "  \n ")
        }

        #expect(apiClient.requests.isEmpty)
    }

}
