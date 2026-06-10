//
//  SearchTMDbToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct SearchTMDbToolTests {

        private struct DummyError: Error {}

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: SearchTMDbTool {
            SearchTMDbTool(searchService: TMDbSearchService(apiClient: apiClient))
        }

        @available(macOS 26, *)
        @Test("returns formatted results carrying ids")
        func returnsResultsWithIDs() async throws {
            let list = MediaPageableList.mock(
                results: [
                    .movie(.mock(id: 27205, title: "Inception")),
                    .person(.mock(id: 287, name: "Brad Pitt", originalName: "Brad Pitt"))
                ]
            )
            apiClient.addResponse(.success(list))

            let output = try await tool.call(arguments: .init(query: "Inception", mediaType: nil))

            #expect(output.contains("movie | 27205"))
            #expect(output.contains("person | 287"))
        }

        @available(macOS 26, *)
        @Test("limits results to the requested media type")
        func filtersByMediaType() async throws {
            let list = MediaPageableList.mock(
                results: [
                    .movie(.mock(id: 1, title: "A Movie")),
                    .person(.mock(id: 2, name: "A Person", originalName: "A Person"))
                ]
            )
            apiClient.addResponse(.success(list))

            let output = try await tool.call(arguments: .init(query: "A", mediaType: .person))

            #expect(output.contains("person | 2"))
            #expect(!output.contains("movie | 1"))
        }

        @available(macOS 26, *)
        @Test("returns a no-results message when nothing matches")
        func noResults() async throws {
            apiClient.addResponse(.success(MediaPageableList.mock(results: [])))

            let output = try await tool.call(arguments: .init(query: "zzz", mediaType: nil))

            #expect(output == "No results found for 'zzz'.")
        }

        @available(macOS 26, *)
        @Test("returns guidance for an empty query without calling the API")
        func emptyQuery() async throws {
            let output = try await tool.call(arguments: .init(query: "   ", mediaType: nil))

            #expect(output.contains("Provide"))
            #expect(apiClient.lastRequest == nil)
        }

        @available(macOS 26, *)
        @Test("rethrows infrastructure errors")
        func rethrowsInfrastructureErrors() async {
            apiClient.addResponse(.failure(.network(DummyError())))

            await #expect(throws: TMDbError.self) {
                _ = try await tool.call(arguments: .init(query: "Inception", mediaType: nil))
            }
        }

    }
#endif
