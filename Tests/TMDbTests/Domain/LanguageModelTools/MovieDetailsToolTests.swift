//
//  MovieDetailsToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct MovieDetailsToolTests {

        private struct DummyError: Error {}

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: MovieDetailsTool {
            MovieDetailsTool(movieService: TMDbMovieService(apiClient: apiClient))
        }

        @available(macOS 26, *)
        @Test("returns a details block carrying the id")
        func returnsDetailsBlock() async throws {
            apiClient.addResponse(.success(Movie.mock(id: 27205, title: "Inception")))

            let output = try await tool.call(arguments: .init(movieID: 27205))

            #expect(output.contains("movie | 27205 | Inception"))
        }

        @available(macOS 26, *)
        @Test("recovers from not found with a readable message")
        func recoversFromNotFound() async throws {
            apiClient.addResponse(.failure(.notFound()))

            let output = try await tool.call(arguments: .init(movieID: 999))

            #expect(output == "No TMDb movie with id 999 found.")
        }

        @available(macOS 26, *)
        @Test("rethrows infrastructure errors")
        func rethrowsInfrastructureErrors() async {
            apiClient.addResponse(.failure(.network(DummyError())))

            await #expect(throws: TMDbError.self) {
                _ = try await tool.call(arguments: .init(movieID: 1))
            }
        }

    }
#endif
