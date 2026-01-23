//
//  TMDbMovieServiceReleaseDatesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceReleaseDatesTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("releaseDates returns release dates by country")
    func releaseDatesReturnsReleaseDatesByCountry() async throws {
        let movieID = 550
        let expectedResult = MovieReleaseDatesResult.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReleaseDatesRequest(id: movieID)

        let result = try await service.releaseDates(forMovie: movieID)

        #expect(result == expectedResult.results)
        #expect(apiClient.lastRequest as? MovieReleaseDatesRequest == expectedRequest)
    }

    @Test("releaseDates when errors throws error")
    func releaseDatesWhenErrorsThrowsError() async throws {
        let movieID = 550
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.releaseDates(forMovie: movieID)
        }
    }

}
