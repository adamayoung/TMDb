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

    @Test("alternativeNames returns alternative names")
    func alternativeNamesReturnsAlternativeNames() async throws {
        let expectedResult = CompanyAlternativeNameCollection.mock()
        let companyID = expectedResult.id
        let expectedRequest = CompanyAlternativeNamesRequest(id: companyID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.alternativeNames(forCompany: companyID)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? CompanyAlternativeNamesRequest
                == expectedRequest
        )
    }

    @Test("alternativeNames when errors throws error")
    func alternativeNamesWhenErrorsThrowsError() async throws {
        let companyID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.alternativeNames(forCompany: companyID)
        }
    }

    @Test("images returns company images")
    func imagesReturnsCompanyImages() async throws {
        let expectedResult = CompanyImageCollection.mock()
        let companyID = expectedResult.id
        let expectedRequest = CompanyImagesRequest(id: companyID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.images(forCompany: companyID)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? CompanyImagesRequest
                == expectedRequest
        )
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let companyID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(forCompany: companyID)
        }
    }

}
