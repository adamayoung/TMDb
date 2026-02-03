//
//  TMDbAccountServiceDetailsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .account))
struct TMDbAccountServiceDetails {

    var service: TMDbAccountService!
    var apiClient: MockAPIClient!
    var session: Session!

    init() {
        self.session = Session(success: true, sessionID: "abc123")
        self.apiClient = MockAPIClient()
        self.service = TMDbAccountService(apiClient: apiClient)
    }

    @Test("details returns account details")
    func detailsReturnsAccountDetails() async throws {
        let expectedResult = AccountDetails.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = AccountRequest(sessionID: session.sessionID)

        let result = try await service.details(session: session)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? AccountRequest == expectedRequest)
    }

    @Test("details when error throws error")
    func detailsWhenErrorThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(session: session)
        }
    }

}
