//
//  TMDbPersonServiceTaggedImagesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct TMDbPersonServiceTaggedImagesTests {

    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbPersonService(apiClient: apiClient)
    }

    @Test(
        "taggedImages with default parameters returns tagged images"
    )
    func taggedImagesWithDefaultParametersReturnsTaggedImages()
    async throws {
        let expectedResult = TaggedImagePageableList.mock()
        let personID = 500
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonTaggedImagesRequest(
            id: personID, page: nil
        )

        let result = try await (service as PersonService)
            .taggedImages(forPerson: personID)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonTaggedImagesRequest
                == expectedRequest
        )
    }

    @Test("taggedImages with page returns tagged images")
    func taggedImagesWithPageReturnsTaggedImages() async throws {
        let expectedResult = TaggedImagePageableList.mock()
        let personID = 500
        let page = 2
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonTaggedImagesRequest(
            id: personID, page: page
        )

        let result = try await service.taggedImages(
            forPerson: personID, page: page
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonTaggedImagesRequest
                == expectedRequest
        )
    }

    @Test("taggedImages when errors throws error")
    func taggedImagesWhenErrorsThrowsError() async throws {
        let personID = 500
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.taggedImages(forPerson: personID)
        }
    }

}
