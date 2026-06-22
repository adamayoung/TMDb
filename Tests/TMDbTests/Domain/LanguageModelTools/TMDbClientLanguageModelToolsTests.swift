//
//  TMDbClientLanguageModelToolsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import FoundationModels
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct TMDbClientLanguageModelToolsTests {

        private let client = TMDbClient(apiKey: "test-api-key")

        @available(macOS 26, *)
        @Test("languageModelTools exposes the eight tools")
        func languageModelToolsCount() {
            #expect(client.languageModelTools.count == 8)
        }

        @available(macOS 26, *)
        @Test("each individual tool property returns the expected tool")
        func individualToolProperties() {
            #expect(client.searchTool.name == "search")
            #expect(client.movieDetailsTool.name == "movieDetails")
            #expect(client.movieCreditsTool.name == "movieCredits")
            #expect(client.tvSeriesDetailsTool.name == "tvSeriesDetails")
            #expect(client.personFilmographyTool.name == "personFilmography")
            #expect(client.trendingTool.name == "trending")
            #expect(client.watchProvidersTool.name == "watchProviders")
            #expect(client.discoverMoviesTool.name == "discoverMovies")
        }

    }
#endif
