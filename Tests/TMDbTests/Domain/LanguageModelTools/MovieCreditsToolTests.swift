//
//  MovieCreditsToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct MovieCreditsToolTests {

        private struct DummyError: Error {}

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: MovieCreditsTool {
            MovieCreditsTool(movieService: TMDbMovieService(apiClient: apiClient))
        }

        @available(macOS 26, *)
        @Test("returns a credits block carrying the movie and person ids")
        func returnsCreditsBlock() async throws {
            apiClient.addResponse(
                .success(
                    ShowCredits.mock(
                        id: 27205,
                        cast: [.mock(id: 6193, name: "Leonardo DiCaprio", character: "Cobb", order: 0)],
                        crew: [.mock(id: 525, name: "Christopher Nolan", job: "Director")]
                    )
                )
            )

            let output = try await tool.call(arguments: .init(movieID: 27205))

            #expect(output.contains("credits | 27205"))
            #expect(output.contains("cast | 6193 | Leonardo DiCaprio as Cobb"))
            #expect(output.contains("crew | 525 | Christopher Nolan — Director"))
        }

        @available(macOS 26, *)
        @Test("caps cast at ten and keeps only key crew jobs")
        func capsCastAndFiltersCrew() async throws {
            let cast = (0 ..< 15).map {
                CastMember.mock(id: $0, name: "Actor \($0)", character: "Role \($0)", order: $0)
            }
            let crew = [
                CrewMember.mock(id: 100, name: "A Director", job: "Director"),
                CrewMember.mock(id: 200, name: "An Editor", job: "Editor")
            ]
            apiClient.addResponse(.success(ShowCredits.mock(id: 1, cast: cast, crew: crew)))

            let output = try await tool.call(arguments: .init(movieID: 1))
            let lines = output.components(separatedBy: "\n")

            #expect(lines.count(where: { $0.hasPrefix("cast |") }) == 10)
            #expect(output.contains("crew | 100 | A Director — Director"))
            #expect(!output.contains("Editor"))
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
