//
//  TrendingToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct TrendingToolTests {

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: TrendingTool {
            TrendingTool(trendingService: TMDbTrendingService(apiClient: apiClient))
        }

        @available(macOS 26, *)
        @Test("returns trending movies carrying ids")
        func trendingMovies() async throws {
            let list = MoviePageableList.mock(results: [.mock(id: 27205, title: "Inception")])
            apiClient.addResponse(.success(list))

            let output = try await tool.call(arguments: .init(mediaType: .movie, timeWindow: .week))

            #expect(output.contains("movie | 27205"))
        }

        @available(macOS 26, *)
        @Test("returns trending TV series carrying ids")
        func trendingTVSeries() async throws {
            let list = TVSeriesPageableList.mock(results: [.mock(id: 1396, name: "Breaking Bad")])
            apiClient.addResponse(.success(list))

            let output = try await tool.call(arguments: .init(mediaType: .tvSeries, timeWindow: .day))

            #expect(output.contains("tv | 1396"))
        }

        @available(macOS 26, *)
        @Test("returns trending people carrying ids")
        func trendingPeople() async throws {
            let list = PersonPageableList.mock(
                results: [.mock(id: 287, name: "Brad Pitt", originalName: "Brad Pitt")]
            )
            apiClient.addResponse(.success(list))

            let output = try await tool.call(arguments: .init(mediaType: .person, timeWindow: .day))

            #expect(output.contains("person | 287"))
        }

    }
#endif
