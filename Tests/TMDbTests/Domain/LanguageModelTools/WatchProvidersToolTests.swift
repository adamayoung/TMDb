//
//  WatchProvidersToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct WatchProvidersToolTests {

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: WatchProvidersTool {
            WatchProvidersTool(
                movieService: TMDbMovieService(apiClient: apiClient),
                tvSeriesService: TMDbTVSeriesService(apiClient: apiClient)
            )
        }

        @available(macOS 26, *)
        @Test("returns providers for the requested movie and country")
        func returnsMovieProviders() async throws {
            apiClient.addResponse(.success(ShowWatchProviderResult.mock(regionCode: "GB")))

            let output = try await tool.call(
                arguments: .init(mediaType: .movie, id: 27205, countryCode: "GB")
            )

            #expect(output.hasPrefix("watchProviders | 27205 | GB"))
            #expect(output.contains("Netflix"))
        }

        @available(macOS 26, *)
        @Test("returns a message when the country has no providers")
        func noProvidersForCountry() async throws {
            apiClient.addResponse(.success(ShowWatchProviderResult.mock(regionCode: "US")))

            let output = try await tool.call(
                arguments: .init(mediaType: .movie, id: 27205, countryCode: "FR")
            )

            #expect(output == "No watch providers found for id 27205 in FR.")
        }

        @available(macOS 26, *)
        @Test("supports TV series")
        func returnsTVSeriesProviders() async throws {
            apiClient.addResponse(.success(ShowWatchProviderResult.mock(regionCode: "US")))

            let output = try await tool.call(
                arguments: .init(mediaType: .tvSeries, id: 1396, countryCode: "us")
            )

            #expect(output.hasPrefix("watchProviders | 1396 | US"))
        }

        @available(macOS 26, *)
        @Test("recovers from not found with a readable message")
        func recoversFromNotFound() async throws {
            apiClient.addResponse(.failure(.notFound()))

            let output = try await tool.call(
                arguments: .init(mediaType: .movie, id: 999, countryCode: "US")
            )

            #expect(output == "No TMDb movie with id 999 found.")
        }

    }
#endif
