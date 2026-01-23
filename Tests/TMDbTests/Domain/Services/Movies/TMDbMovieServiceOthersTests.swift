//
//  TMDbMovieServiceOthersTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceOthersTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("watchProviders returns watch providers for all countries")
    func watchProvidersReturnsWatchProvidersForAllCountries() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let movieID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchProvidersRequest(id: movieID)

        let result = try await service.watchProviders(forMovie: movieID)

        #expect(result.count == expectedResult.results.count)
        for item in result {
            #expect(expectedResult.results[item.countryCode] == item.watchProviders)
        }
        #expect(apiClient.lastRequest as? MovieWatchProvidersRequest == expectedRequest)
    }

    @Test("watchProviders when errors throws error")
    func watchProvidersWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.watchProviders(forMovie: movieID)
        }
    }

    @Test("extraLinks returns external links")
    func externalLinksReturnsExternalLinks() async throws {
        let expectedResult = MovieExternalLinksCollection.barbie
        let movieID = 346_698
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieExternalLinksRequest(id: movieID)

        let result = try await service.externalLinks(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieExternalLinksRequest == expectedRequest)
    }

    @Test("extraLinks when errors throws error")
    func externalLinksWhenErrorsThrowsError() async throws {
        let movieID = 346_698
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.externalLinks(forMovie: movieID)
        }
    }

}
