//
//  DiscoverMoviesToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct DiscoverMoviesToolTests {

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: DiscoverMoviesTool {
            DiscoverMoviesTool(
                discoverService: TMDbDiscoverService(apiClient: apiClient),
                watchProviderService: TMDbWatchProviderService(apiClient: apiClient)
            )
        }

        @available(macOS 26, *)
        @Test("returns movies matching genre, year and rating")
        func discoversByAttributes() async throws {
            let list = MoviePageableList.mock(results: [.mock(id: 27205, title: "Inception")])
            apiClient.addResponse(.success(list))

            let output = try await tool.call(
                arguments: .init(
                    genre: .thriller,
                    yearFrom: 2010,
                    yearTo: 2019,
                    minRating: 7,
                    watchProvider: nil,
                    watchRegion: nil
                )
            )

            #expect(output.contains("movie | 27205"))
        }

        @available(macOS 26, *)
        @Test("resolves a provider name and returns matching movies")
        func discoversByProvider() async throws {
            apiClient.addResponse(.success(WatchProviderResult.mock))
            apiClient.addResponse(
                .success(MoviePageableList.mock(results: [.mock(id: 1, title: "A Thriller")]))
            )

            let output = try await tool.call(
                arguments: .init(
                    genre: .thriller,
                    yearFrom: nil,
                    yearTo: nil,
                    minRating: nil,
                    watchProvider: "Netflix",
                    watchRegion: "GB"
                )
            )

            #expect(output.contains("movie | 1"))
        }

        @available(macOS 26, *)
        @Test("returns guidance for an unknown provider without discovering")
        func unknownProvider() async throws {
            apiClient.addResponse(.success(WatchProviderResult.mock))

            let output = try await tool.call(
                arguments: .init(
                    genre: nil,
                    yearFrom: nil,
                    yearTo: nil,
                    minRating: nil,
                    watchProvider: "Nonexistent Service",
                    watchRegion: "GB"
                )
            )

            #expect(output.contains("Unknown streaming provider 'Nonexistent Service'"))
        }

        @available(macOS 26, *)
        @Test("works with no filters")
        func noFilters() async throws {
            apiClient.addResponse(.success(MoviePageableList.mock(results: [.mock(id: 9, title: "X")])))

            let output = try await tool.call(
                arguments: .init(
                    genre: nil,
                    yearFrom: nil,
                    yearTo: nil,
                    minRating: nil,
                    watchProvider: nil,
                    watchRegion: nil
                )
            )

            #expect(output.contains("movie | 9"))
        }

    }
#endif
