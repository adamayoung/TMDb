//
//  TMDbCompanyServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .company))
struct TMDbCompanyServiceTests {

    var service: TMDbCompanyService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbCompanyService(apiClient: apiClient)
    }

    @Test("details returns company")
    func detailsReturnsCompany() async throws {
        let expectedResult = Company.lucasfilm
        let companyID = expectedResult.id
        let expectedRequest = CompanyDetailsRequest(id: companyID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(forCompany: companyID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CompanyDetailsRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let companyID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forCompany: companyID)
        }
    }

}
