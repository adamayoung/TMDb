//
//  TMDbMovieServiceMediaTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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

    @Test("images with default parameter values returns image collection")
    func imagesReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieImagesRequest(id: movieID, languages: nil)

        let result = try await (service as MovieService).images(forMovie: movieID)

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

    @Test("videos with default parameter values returns video collection")
    func videosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieVideosRequest(id: movieID, languages: nil)

        let result = try await (service as MovieService).videos(forMovie: movieID)

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
