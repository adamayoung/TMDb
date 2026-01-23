//
//  TMDbFindServiceTests.swift
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

@Suite(.tags(.services, .find))
struct TMDbFindServiceTests {

    var service: TMDbFindService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbFindService(apiClient: apiClient)
    }

    @Test("find with IMDb ID returns movie results")
    func findWithIMDbIDReturnsMovieResults() async throws {
        let externalID = "tt0111161"
        let externalSource = ExternalSource.imdbID
        let expectedResult = FindResults.movieResult
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FindByIDRequest(
            externalID: externalID,
            externalSource: externalSource,
            language: nil
        )

        let result = try await (service as FindService).find(
            externalID: externalID,
            externalSource: externalSource
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FindByIDRequest == expectedRequest)
    }

    @Test("find with TVDB ID returns TV series results")
    func findWithTVDBIDReturnsTVSeriesResults() async throws {
        let externalID = "81189"
        let externalSource = ExternalSource.tvdbID
        let expectedResult = FindResults.tvSeriesResult
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FindByIDRequest(
            externalID: externalID,
            externalSource: externalSource,
            language: nil
        )

        let result = try await (service as FindService).find(
            externalID: externalID,
            externalSource: externalSource
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FindByIDRequest == expectedRequest)
    }

    @Test("find with language returns results")
    func findWithLanguageReturnsResults() async throws {
        let externalID = "tt0111161"
        let externalSource = ExternalSource.imdbID
        let language = "en"
        let expectedResult = FindResults.movieResult
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FindByIDRequest(
            externalID: externalID,
            externalSource: externalSource,
            language: language
        )

        let result = try await service.find(
            externalID: externalID,
            externalSource: externalSource,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FindByIDRequest == expectedRequest)
    }

    @Test("find when errors throws error")
    func findWhenErrorsThrowsError() async throws {
        let externalID = "invalid"
        let externalSource = ExternalSource.imdbID
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.find(externalID: externalID, externalSource: externalSource)
        }
    }

}
