//
//  TMDbSearchServiceCollectionsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct TMDbSearchServiceCollectionsTests {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbSearchService(apiClient: apiClient)
    }

    @Test(
        "searchCollections with default parameters returns collections"
    )
    func searchCollectionsWithDefaultParametersReturnsCollections()
    async throws {
        let query = "marvel"
        let expectedResult = CollectionPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CollectionSearchRequest(
            query: query, page: nil, language: nil
        )

        let result = try await (service as SearchService)
            .searchCollections(query: query)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? CollectionSearchRequest
                == expectedRequest
        )
    }

    @Test(
        "searchCollections with page and language returns collections"
    )
    func searchCollectionsWithPageAndLanguageReturnsCollections()
    async throws {
        let query = "marvel"
        let page = 2
        let language = "en"
        let expectedResult = CollectionPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CollectionSearchRequest(
            query: query, page: page, language: language
        )

        let result = try await service.searchCollections(
            query: query, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? CollectionSearchRequest
                == expectedRequest
        )
    }

    @Test("searchCollections when errors throws error")
    func searchCollectionsWhenErrorsThrowsError() async throws {
        let query = "marvel"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchCollections(query: query)
        }
    }

}
