//
//  TMDbCollectionServiceDetailsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .collection))
struct TMDbCollectionServiceDetailsTests {

    var service: TMDbCollectionService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbCollectionService(apiClient: apiClient)
    }

    @Test("details with default parameter values returns collection")
    func detailsWithDefaultParameterValuesReturnsCollection() async throws {
        let expectedResult = Collection.mock
        let collectionID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CollectionRequest(id: collectionID, language: nil)

        let result = try await (service as CollectionService).details(
            forCollection: collectionID,
            language: nil
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CollectionRequest == expectedRequest)
    }

    @Test("details with language returns collection")
    func detailsWithLanguageReturnsCollection() async throws {
        let expectedResult = Collection.mock
        let collectionID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CollectionRequest(id: collectionID, language: language)

        let result = try await service.details(forCollection: collectionID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CollectionRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let collectionID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forCollection: collectionID)
        }
    }

}
