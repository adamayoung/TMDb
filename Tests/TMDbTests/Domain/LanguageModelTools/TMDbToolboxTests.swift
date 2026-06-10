//
//  TMDbToolboxTests.swift
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
    struct TMDbToolboxTests {

        @available(macOS 26, *)
        private func makeToolbox(language: String? = nil, region: String? = nil) -> TMDbToolbox {
            let apiClient = MockAPIClient()
            return TMDbToolbox(
                movieService: TMDbMovieService(apiClient: apiClient),
                tvSeriesService: TMDbTVSeriesService(apiClient: apiClient),
                personService: TMDbPersonService(apiClient: apiClient),
                searchService: TMDbSearchService(apiClient: apiClient),
                trendingService: TMDbTrendingService(apiClient: apiClient),
                discoverService: TMDbDiscoverService(apiClient: apiClient),
                watchProviderService: TMDbWatchProviderService(apiClient: apiClient),
                language: language,
                region: region
            )
        }

        @available(macOS 26, *)
        @Test("all exposes the seven tools")
        func allHasSevenTools() {
            #expect(makeToolbox().all.count == 7)
        }

        @available(macOS 26, *)
        @Test("tools expose stable, frozen names")
        func toolNames() {
            let names = makeToolbox().all.map(\.name).sorted()
            #expect(
                names == [
                    "discoverMovies",
                    "movieDetails",
                    "personFilmography",
                    "search",
                    "trending",
                    "tvSeriesDetails",
                    "watchProviders"
                ]
            )
        }

        @available(macOS 26, *)
        @Test("every tool has a non-empty description")
        func toolDescriptions() {
            for tool in makeToolbox().all {
                #expect(!tool.description.isEmpty)
            }
        }

        @available(macOS 26, *)
        @Test("the retrieval trio descriptions disambiguate one another")
        func retrievalTrioDisambiguation() {
            let toolbox = makeToolbox()
            #expect(toolbox.search.description.contains("discoverMovies"))
            #expect(toolbox.search.description.contains("trending"))
            #expect(toolbox.discoverMovies.description.contains("Browse"))
        }

        @available(macOS 26, *)
        @Test("each accessor returns the expected tool")
        func accessorsWireToTheRightTools() {
            let toolbox = makeToolbox()
            #expect(toolbox.search.name == "search")
            #expect(toolbox.movieDetails.name == "movieDetails")
            #expect(toolbox.tvSeriesDetails.name == "tvSeriesDetails")
            #expect(toolbox.personFilmography.name == "personFilmography")
            #expect(toolbox.trending.name == "trending")
            #expect(toolbox.watchProviders.name == "watchProviders")
            #expect(toolbox.discoverMovies.name == "discoverMovies")
        }

    }
#endif
