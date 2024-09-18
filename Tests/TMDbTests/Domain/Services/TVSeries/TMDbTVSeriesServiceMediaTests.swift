//
//  TMDbTVSeriesServiceMediaTests.swift
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
struct TMDbTVSeriesServiceMediaTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("images returns images")
    func imagesReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesImagesRequest(id: tvSeriesID, languages: nil)

        let result = try await service.images(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesImagesRequest == expectedRequest)
    }

    @Test("images with filter returns images")
    func imagesWithFilterReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let languages = ["en-GB", "fr"]
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesImagesRequest(id: tvSeriesID, languages: languages)

        let filter = TVSeriesImageFilter(languages: languages)
        let result = try await service.images(forTVSeries: tvSeriesID, filter: filter)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesImagesRequest == expectedRequest)
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(forTVSeries: tvSeriesID)
        }
    }

    @Test("video returns videos")
    func videosReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesVideosRequest(id: tvSeriesID, languages: nil)

        let result = try await service.videos(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesVideosRequest == expectedRequest)
    }

    @Test("videos with filter returns videos")
    func videosWithFilterReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        let languages = ["en", "fr"]
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesVideosRequest(id: tvSeriesID, languages: languages)

        let filter = TVSeriesVideoFilter(languages: languages)
        let result = try await service.videos(forTVSeries: tvSeriesID, filter: filter)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesVideosRequest == expectedRequest)
    }

    @Test("video when errors throws error")
    func videosWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.videos(forTVSeries: tvSeriesID)
        }
    }

}
