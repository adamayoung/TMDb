//
//  TMDbTVSeriesServiceListsTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceListsTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("recommenendations returns TV series")
    func recommendationsReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRecommendationsRequest(
            id: tvSeriesID,
            page: nil,
            language: nil
        )

        let result = try await service.recommendations(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesRecommendationsRequest == expectedRequest)
    }

    @Test("recommendations with page and language returns TV series")
    func recommendationsWithPageAndLanguageReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRecommendationsRequest(
            id: tvSeriesID, page: page, language: language)

        let result = try await service.recommendations(
            forTVSeries: tvSeriesID, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesRecommendationsRequest == expectedRequest)
    }

    @Test("recommendations when errors throws error")
    func recommendationsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.recommendations(forTVSeries: tvSeriesID)
        }
    }

    @Test("similar returns TV series")
    func similarReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarTVSeriesRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await service.similar(toTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? SimilarTVSeriesRequest == expectedRequest)
    }

    @Test("similar with page and language returns TV series")
    func similarWithPageAndLanguageReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarTVSeriesRequest(id: tvSeriesID, page: page, language: language)

        let result = try await service.similar(
            toTVSeries: tvSeriesID, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? SimilarTVSeriesRequest == expectedRequest)
    }

    @Test("similar when errors throws error")
    func similarWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.similar(toTVSeries: tvSeriesID)
        }
    }

    @Test("popular returns TV series")
    func popularReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularTVSeriesRequest(page: nil, language: nil)

        let result = try await service.popular()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularTVSeriesRequest == expectedRequest)
    }

    @Test("popular with page and language returns TV series")
    func popularWithPageAndLanguageReturnsTVSeries() async throws {
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularTVSeriesRequest(page: page, language: language)

        let result = try await service.popular(page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularTVSeriesRequest == expectedRequest)
    }

    @Test("popular when errors throws error")
    func popularWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.popular()
        }
    }

}
