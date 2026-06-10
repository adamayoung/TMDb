//
//  PersonFilmographyToolTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct PersonFilmographyToolTests {

        private let apiClient = MockAPIClient()

        @available(macOS 26, *)
        private var tool: PersonFilmographyTool {
            PersonFilmographyTool(personService: TMDbPersonService(apiClient: apiClient))
        }

        @available(macOS 26, *)
        @Test("returns a person header followed by credit lines")
        func returnsHeaderAndCredits() async throws {
            apiClient.addResponse(
                .success(Person.mock(id: 287, name: "Brad Pitt", knownForDepartment: "Acting"))
            )
            apiClient.addResponse(.success(PersonCombinedCredits.mock(id: 287)))

            let output = try await tool.call(arguments: .init(personID: 287, maxCredits: nil))
            let lines = output.components(separatedBy: "\n")

            #expect(lines.first == "person | 287 | Brad Pitt | Acting")
            #expect(lines.count > 1)
        }

        @available(macOS 26, *)
        @Test("orders credits by popularity, most notable first")
        func ordersByPopularity() async throws {
            let credits = PersonCombinedCredits(
                id: 287,
                cast: [
                    .movie(.mock(id: 10, title: "Less Popular", popularity: 5)),
                    .movie(.mock(id: 20, title: "More Popular", popularity: 90))
                ],
                crew: []
            )
            apiClient.addResponse(.success(Person.mock(id: 287, name: "Brad Pitt")))
            apiClient.addResponse(.success(credits))

            let output = try await tool.call(arguments: .init(personID: 287, maxCredits: nil))
            let morePopular = try #require(output.range(of: "movie | 20"))
            let lessPopular = try #require(output.range(of: "movie | 10"))

            #expect(morePopular.lowerBound < lessPopular.lowerBound)
        }

        @available(macOS 26, *)
        @Test("limits the number of credits to maxCredits")
        func limitsCredits() async throws {
            let credits = PersonCombinedCredits(
                id: 287,
                cast: [
                    .movie(.mock(id: 10, popularity: 5)),
                    .movie(.mock(id: 20, popularity: 90)),
                    .movie(.mock(id: 30, popularity: 50))
                ],
                crew: []
            )
            apiClient.addResponse(.success(Person.mock(id: 287, name: "Brad Pitt")))
            apiClient.addResponse(.success(credits))

            let output = try await tool.call(arguments: .init(personID: 287, maxCredits: 1))

            // Header line + exactly one credit line.
            #expect(output.components(separatedBy: "\n").count == 2)
        }

        @available(macOS 26, *)
        @Test("recovers from not found with a readable message")
        func recoversFromNotFound() async throws {
            apiClient.addResponse(.failure(.notFound()))

            let output = try await tool.call(arguments: .init(personID: 999, maxCredits: nil))

            #expect(output == "No TMDb person with id 999 found.")
        }

    }
#endif
