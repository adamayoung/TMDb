//
//  TMDbSearchServiceCompaniesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct TMDbSearchServiceCompaniesTests {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbSearchService(apiClient: apiClient)
    }

    @Test(
        "searchCompanies with default parameters returns companies"
    )
    func searchCompaniesWithDefaultParametersReturnsCompanies()
    async throws {
        let query = "marvel"
        let expectedResult = CompanyPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CompanySearchRequest(
            query: query, page: nil
        )

        let result = try await (service as SearchService)
            .searchCompanies(query: query)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? CompanySearchRequest
                == expectedRequest
        )
    }

    @Test("searchCompanies with page returns companies")
    func searchCompaniesWithPageReturnsCompanies() async throws {
        let query = "marvel"
        let page = 2
        let expectedResult = CompanyPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CompanySearchRequest(
            query: query, page: page
        )

        let result = try await service.searchCompanies(
            query: query, page: page
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? CompanySearchRequest
                == expectedRequest
        )
    }

    @Test("searchCompanies when errors throws error")
    func searchCompaniesWhenErrorsThrowsError() async throws {
        let query = "marvel"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchCompanies(query: query)
        }
    }

}
