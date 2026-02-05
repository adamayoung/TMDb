//
//  TMDbSearchServiceKeywordsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct TMDbSearchServiceKeywordsTests {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbSearchService(apiClient: apiClient)
    }

    @Test(
        "searchKeywords with default parameters returns keywords"
    )
    func searchKeywordsWithDefaultParametersReturnsKeywords()
    async throws {
        let query = "marvel"
        let expectedResult = KeywordPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = KeywordSearchRequest(
            query: query, page: nil
        )

        let result = try await (service as SearchService)
            .searchKeywords(query: query)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? KeywordSearchRequest
                == expectedRequest
        )
    }

    @Test("searchKeywords with page returns keywords")
    func searchKeywordsWithPageReturnsKeywords() async throws {
        let query = "marvel"
        let page = 2
        let expectedResult = KeywordPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = KeywordSearchRequest(
            query: query, page: page
        )

        let result = try await service.searchKeywords(
            query: query, page: page
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? KeywordSearchRequest
                == expectedRequest
        )
    }

    @Test("searchKeywords when errors throws error")
    func searchKeywordsWhenErrorsThrowsError() async throws {
        let query = "marvel"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchKeywords(query: query)
        }
    }

}
