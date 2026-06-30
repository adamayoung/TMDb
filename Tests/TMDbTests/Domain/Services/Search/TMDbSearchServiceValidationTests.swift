//
//  TMDbSearchServiceValidationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .search))
struct TMDbSearchServiceValidationTests {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbSearchService(apiClient: apiClient)
    }

    static let expectedError = TMDbError.badRequest("Search query must not be empty")

    @Test("searchAll with empty query throws bad request and performs no request")
    func searchAllWithEmptyQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchAll(query: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchAll with whitespace query throws bad request and performs no request")
    func searchAllWithWhitespaceQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchAll(query: "   ")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchMovies with empty query throws bad request and performs no request")
    func searchMoviesWithEmptyQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchMovies(query: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchMovies with whitespace query throws bad request and performs no request")
    func searchMoviesWithWhitespaceQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchMovies(query: "\t\n ")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchTVSeries with empty query throws bad request and performs no request")
    func searchTVSeriesWithEmptyQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchTVSeries(query: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchTVSeries with whitespace query throws bad request and performs no request")
    func searchTVSeriesWithWhitespaceQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchTVSeries(query: "  \t")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchPeople with empty query throws bad request and performs no request")
    func searchPeopleWithEmptyQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchPeople(query: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchPeople with whitespace query throws bad request and performs no request")
    func searchPeopleWithWhitespaceQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchPeople(query: " \n ")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchCollections with empty query throws bad request and performs no request")
    func searchCollectionsWithEmptyQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchCollections(query: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchCollections with whitespace query throws bad request and performs no request")
    func searchCollectionsWithWhitespaceQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchCollections(query: "\t")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchCompanies with empty query throws bad request and performs no request")
    func searchCompaniesWithEmptyQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchCompanies(query: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchCompanies with whitespace query throws bad request and performs no request")
    func searchCompaniesWithWhitespaceQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchCompanies(query: "   \n")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchKeywords with empty query throws bad request and performs no request")
    func searchKeywordsWithEmptyQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchKeywords(query: "")
        }

        #expect(apiClient.requests.isEmpty)
    }

    @Test("searchKeywords with whitespace query throws bad request and performs no request")
    func searchKeywordsWithWhitespaceQueryThrowsBadRequest() async throws {
        await #expect(throws: Self.expectedError) {
            _ = try await service.searchKeywords(query: "\n\t ")
        }

        #expect(apiClient.requests.isEmpty)
    }

}
