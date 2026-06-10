//
//  TVSeriesDetailsToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct TVSeriesDetailsToolTests {

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: TVSeriesDetailsTool {
            TVSeriesDetailsTool(tvSeriesService: TMDbTVSeriesService(apiClient: apiClient))
        }

        @available(macOS 26, *)
        @Test("returns a details block carrying the id")
        func returnsDetailsBlock() async throws {
            apiClient.addResponse(.success(TVSeries.mock(id: 1396, name: "Breaking Bad")))

            let output = try await tool.call(arguments: .init(tvSeriesID: 1396))

            #expect(output.contains("tv | 1396 | Breaking Bad"))
        }

        @available(macOS 26, *)
        @Test("recovers from not found with a readable message")
        func recoversFromNotFound() async throws {
            apiClient.addResponse(.failure(.notFound()))

            let output = try await tool.call(arguments: .init(tvSeriesID: 999))

            #expect(output == "No TMDb TV series with id 999 found.")
        }

    }
#endif
