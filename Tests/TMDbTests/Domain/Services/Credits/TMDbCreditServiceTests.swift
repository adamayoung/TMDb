//
//  TMDbCreditServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .credit))
struct TMDbCreditServiceTests {

    var service: TMDbCreditService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbCreditService(
            apiClient: apiClient
        )
    }

    @Test("details returns credit")
    func detailsReturnsCredit() async throws {
        let expectedResult = Credit.mock()
        let creditID = expectedResult.id
        let expectedRequest = CreditRequest(id: creditID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(
            forCredit: creditID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? CreditRequest
                == expectedRequest
        )
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let creditID = "invalid"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forCredit: creditID
            )
        }
    }

    @Test("details with empty ID throws bad request and performs no request")
    func detailsWithEmptyIDThrowsBadRequest() async throws {
        await #expect(throws: TMDbError.badRequest("Credit ID must not be empty")) {
            _ = try await service.details(forCredit: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("details with whitespace ID throws bad request and performs no request")
    func detailsWithWhitespaceIDThrowsBadRequest() async throws {
        await #expect(throws: TMDbError.badRequest("Credit ID must not be empty")) {
            _ = try await service.details(forCredit: "  \n ")
        }

        #expect(apiClient.requests.isEmpty)
    }

}
