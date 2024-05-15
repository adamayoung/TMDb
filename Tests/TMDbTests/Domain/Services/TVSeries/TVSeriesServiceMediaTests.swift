//
//  TVSeriesServiceMediaTests.swift
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

@testable import TMDb
import XCTest

final class TVSeriesServiceMediaTests: XCTestCase {

    var service: TVSeriesService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TVSeriesService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testImagesReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesImagesRequest(id: tvSeriesID, languages: nil)

        let result = try await service.images(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesImagesRequest, expectedRequest)
    }

    func testImagesWithFilterReturnsImages() async throws {
        let tvSeriesID = Int.randomID
        let languages = ["en-GB", "fr"]
        let expectedResult = ImageCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesImagesRequest(id: tvSeriesID, languages: languages)

        let filter = TVSeriesImageFilter(languages: languages)
        let result = try await service.images(forTVSeries: tvSeriesID, filter: filter)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesImagesRequest, expectedRequest)
    }

    func testImagesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.images(forTVSeries: tvSeriesID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testVideosReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesVideosRequest(id: tvSeriesID, languages: nil)

        let result = try await service.videos(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesVideosRequest, expectedRequest)
    }

    func testVideosWithFilterReturnsVideos() async throws {
        let expectedResult = VideoCollection.mock()
        let tvSeriesID = expectedResult.id
        let languages = ["en", "fr"]
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesVideosRequest(id: tvSeriesID, languages: languages)

        let filter = TVSeriesVideoFilter(languages: languages)
        let result = try await service.videos(forTVSeries: tvSeriesID, filter: filter)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesVideosRequest, expectedRequest)
    }

    func testVideosWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.videos(forTVSeries: tvSeriesID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
