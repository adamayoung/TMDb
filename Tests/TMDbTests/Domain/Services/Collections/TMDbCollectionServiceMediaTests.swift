//
//  TMDbCollectionServiceMediaTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .collection))
struct TMDbCollectionServiceMediaTests {

    var service: TMDbCollectionService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbCollectionService(apiClient: apiClient)
    }

    @Test("images with default parameter values returns collection image collection")
    func imagesWithDefaultParameterValuesReturnsCollectionImageCollection() async throws {
        let collectionID = 10
        let expectedResult = CollectionImageCollection.mock
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CollectionImagesRequest(id: collectionID, languages: nil)

        let result = try await (service as CollectionService).images(
            forCollection: collectionID,
            languages: nil
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CollectionImagesRequest == expectedRequest)
    }

    @Test("images with languages returns collection image collection")
    func imagesWithLanguagesReturnsCollectionImageCollection() async throws {
        let collectionID = 10
        let languages = ["en", "fr"]
        let expectedResult = CollectionImageCollection.mock
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CollectionImagesRequest(id: collectionID, languages: languages)

        let result = try await service.images(forCollection: collectionID, languages: languages)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CollectionImagesRequest == expectedRequest)
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let collectionID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(forCollection: collectionID)
        }
    }

    @Test("translations returns collection translations")
    func translationsReturnsCollectionTranslations() async throws {
        let collectionID = 10
        let expectedResult = [CollectionTranslation].mocks
        let wrappedResult = CollectionTranslationsResult(
            id: collectionID,
            translations: expectedResult
        )
        apiClient.addResponse(.success(wrappedResult))
        let expectedRequest = CollectionTranslationsRequest(id: collectionID)

        let result = try await service.translations(forCollection: collectionID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CollectionTranslationsRequest == expectedRequest)
    }

    @Test("translations when errors throws error")
    func translationsWhenErrorsThrowsError() async throws {
        let collectionID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.translations(forCollection: collectionID)
        }
    }

}
