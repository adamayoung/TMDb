//
//  TMDbMovieServiceLatestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceLatestTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("latest returns latest movie")
    func latestReturnsLatestMovie() async throws {
        let expectedResult = Movie.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = LatestMovieRequest()

        let result = try await service.latest()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? LatestMovieRequest == expectedRequest)
    }

    @Test("latest when errors throws error")
    func latestWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.latest()
        }
    }

}
