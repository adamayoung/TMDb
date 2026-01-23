//
//  TMDbWatchProviderServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .watchProvider))
struct TMDbWatchProviderServiceTests {

    var service: TMDbWatchProviderService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbWatchProviderService(apiClient: apiClient)
    }

    @Test("countries with default parameter values returns countries")
    func countriesWithDefaultParameterValuesReturnsCountries() async throws {
        let regions = WatchProviderRegions.mock
        let expectedResult = regions.results
        apiClient.addResponse(.success(regions))
        let expectedRequest = WatchProviderRegionsRequest(language: nil)

        let result = try await (service as WatchProviderService).countries()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? WatchProviderRegionsRequest == expectedRequest)
    }

    @Test("countries with language returns countries")
    func countriesWithLanguageReturnsCountries() async throws {
        let regions = WatchProviderRegions.mock
        let language = "en"
        let expectedResult = regions.results
        apiClient.addResponse(.success(regions))
        let expectedRequest = WatchProviderRegionsRequest(language: language)

        let result = try await service.countries(language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? WatchProviderRegionsRequest == expectedRequest)
    }

    @Test("countries when errors throws error")
    func countriesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.countries()
        }
    }

    @Test("movingWatchProviders with default parameter values returns watch providers")
    func movieWatchProvidersWithDefaultParameterValuesReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForMoviesRequest(country: nil, language: nil)

        let result = try await (service as WatchProviderService).movieWatchProviders()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? WatchProvidersForMoviesRequest == expectedRequest)
    }

    @Test("movieWatchProviders with filter and language returns watch providers")
    func movieWatchProvidersWithFilterAndLanguageReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let country = "GB"
        let language = "en"
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForMoviesRequest(country: country, language: language)

        let filter = WatchProviderFilter(country: country)
        let result = try await service.movieWatchProviders(filter: filter, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? WatchProvidersForMoviesRequest == expectedRequest)
    }

    @Test("movieWatchProviders when errors throws error")
    func movieWatchProvidersWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movieWatchProviders()
        }
    }

    @Test("tvSeriesWatchProviders with default parameter values returns watch providers")
    func tvSeriesWatchProvidersWithDefaultParameterValuesReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForTVSeriesRequest(country: nil, language: nil)

        let result = try await (service as WatchProviderService).tvSeriesWatchProviders()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? WatchProvidersForTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeriesWatchProviders with filter and language returns watch providers")
    func tvSeriesWatchProvidersWithFilterAndLanguageReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let country = "GB"
        let language = "en"
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForTVSeriesRequest(country: country, language: language)

        let filter = WatchProviderFilter(country: country)
        let result = try await service.tvSeriesWatchProviders(filter: filter, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? WatchProvidersForTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeriesWatchProviders when errors throws error")
    func tvSeriesWatchProvidersWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeriesWatchProviders()
        }
    }

}
