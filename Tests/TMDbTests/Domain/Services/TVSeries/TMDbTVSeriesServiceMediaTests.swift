//
//  TMDbTVSeriesServiceMediaTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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

    @Test("images with default parameter values returns images")
    func imagesWithDefaultParameterValuesReturnsImages() async throws {
        let tvSeriesID = 1
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesImagesRequest(id: tvSeriesID, languages: nil)

        let result = try await (service as TVSeriesService).images(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesImagesRequest == expectedRequest)
    }

    @Test("images with filter returns images")
    func imagesWithFilterReturnsImages() async throws {
        let tvSeriesID = 1
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

    @Test("video with default parameter values returns videos")
    func videosWithDefaultParameterValuesReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesVideosRequest(id: tvSeriesID, languages: nil)

        let result = try await (service as TVSeriesService).videos(forTVSeries: tvSeriesID)

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
