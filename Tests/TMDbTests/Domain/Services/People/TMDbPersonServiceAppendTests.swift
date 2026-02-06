//
//  TMDbPersonServiceAppendTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .people))
struct TMDbPersonServiceAppendTests {

    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbPersonService(apiClient: apiClient)
    }

    @Test("details with append returns response")
    func detailsWithAppendReturnsResponse() async throws {
        let expectedResult = PersonDetailsResponse(
            person: .bradPitt
        )
        let personID = expectedResult.person.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonDetailsAppendRequest(
            id: personID,
            appendToResponse: [.movieCredits, .images],
            language: nil
        )

        let result = try await (service as PersonService).details(
            forPerson: personID,
            appending: [.movieCredits, .images]
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append and language returns response")
    func detailsWithAppendAndLanguageReturnsResponse() async throws {
        let expectedResult = PersonDetailsResponse(
            person: .bradPitt
        )
        let personID = expectedResult.person.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonDetailsAppendRequest(
            id: personID,
            appendToResponse: .movieCredits,
            language: language
        )

        let result = try await service.details(
            forPerson: personID,
            appending: .movieCredits,
            language: language
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonDetailsAppendRequest
                == expectedRequest
        )
    }

    @Test("details with append when errors throws error")
    func detailsWithAppendWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(
                forPerson: personID,
                appending: .movieCredits
            )
        }
    }

}
