//
//  TMDbTVSeriesServiceOthersTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceOthersTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("watchProviders returns watch providers for all countries")
    func watchProvidersReturnsWatchProvidersForAllCountries() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesWatchProvidersRequest(id: tvSeriesID)

        let result = try await service.watchProviders(forTVSeries: tvSeriesID)

        #expect(result.count == expectedResult.results.count)
        for item in result {
            #expect(expectedResult.results[item.countryCode] == item.watchProviders)
        }
        #expect(apiClient.lastRequest as? TVSeriesWatchProvidersRequest == expectedRequest)
    }

    @Test("watchProviders when errors throws error")
    func watchProvidersWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.watchProviders(forTVSeries: tvSeriesID)
        }
    }

    @Test("externalLinks returns external links")
    func externalLinksReturnsExternalLinks() async throws {
        let expectedResult = TVSeriesExternalLinksCollection.lockeAndKey
        let tvSeriesID = 86423
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesExternalLinksRequest(id: tvSeriesID)

        let result = try await service.externalLinks(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesExternalLinksRequest == expectedRequest)
    }

    @Test("externalLinks when errors throws error")
    func externalLinksWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.externalLinks(forTVSeries: tvSeriesID)
        }
    }

}
