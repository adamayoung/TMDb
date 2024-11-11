//
//  TMDbTVSeriesServiceCreditsTests.swift
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
struct TMDbTVSeriesServiceCreditsTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("credits returns TV series credits")
    func creditsReturnsTVSeriesCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesCreditsRequest(id: tvSeriesID, language: nil)

        let result = try await service.credits(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesCreditsRequest == expectedRequest)
    }

    @Test("credits with language returns TV series credits")
    func creditsWithLanguageReturnsTVSeriesCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let tvSeriesID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesCreditsRequest(id: tvSeriesID, language: language)

        let result = try await service.credits(forTVSeries: tvSeriesID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesCreditsRequest == expectedRequest)
    }

    @Test("credit when errors throws error")
    func creditsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.credits(forTVSeries: tvSeriesID)
        }
    }

    @Test("aggregateCredits returns TV series credits")
    func aggregateCreditsReturnsTVSeriesCredits() async throws {
        let expectedResult = TVSeriesAggregateCredits(id: 1, cast: [], crew: [])
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: nil)

        let result = try await service.aggregateCredits(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesAggregateCreditsRequest == expectedRequest)
    }

    @Test("aggregateCredits with language returns TV series credits")
    func aggregateCreditsWithLanguageReturnsTVSeriesCredits() async throws {
        let expectedResult = TVSeriesAggregateCredits(id: 1, cast: [], crew: [])
        let tvSeriesID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: language)

        let result = try await service.aggregateCredits(forTVSeries: tvSeriesID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesAggregateCreditsRequest == expectedRequest)
    }

    @Test("aggregateCredits when errors throws error")
    func aggregateCreditsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.aggregateCredits(forTVSeries: tvSeriesID)
        }
    }

}
