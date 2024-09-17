//
//  TMDbMovieServiceMediaTests.swift
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

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceMediaTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("images returns image collection")
    func imagesReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieImagesRequest(id: movieID, languages: nil)

        let result = try await service.images(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieImagesRequest == expectedRequest)
    }

    @Test("images with filter returns image collection")
    func imagesWithFilterReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        let languages = ["en-GB", "fr"]
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieImagesRequest(id: movieID, languages: languages)

        let filter = MovieImageFilter(languages: languages)
        let result = try await service.images(forMovie: movieID, filter: filter)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieImagesRequest == expectedRequest)
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(forMovie: movieID)
        }
    }

    @Test("videos returns video collection")
    func videosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieVideosRequest(id: movieID, languages: nil)

        let result = try await service.videos(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieVideosRequest == expectedRequest)
    }

    @Test("videos with filter returns video collection")
    func videosWithFilterReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        let languages = ["en", "fr"]
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieVideosRequest(id: movieID, languages: languages)

        let filter = MovieVideoFilter(languages: languages)
        let result = try await service.videos(forMovie: movieID, filter: filter)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieVideosRequest == expectedRequest)
    }

    @Test("videos when errors throws error")
    func videosWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.videos(forMovie: movieID)
        }
    }

}
