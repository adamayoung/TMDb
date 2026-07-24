//
//  ErrorContextIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .integrationGate,
    .serialized,
    .tags(.movie),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ErrorContextIntegrationTests {

    var movieService: (any MovieService)!

    init() {
        self.movieService = CredentialHelper.shared.makeClient().movies
    }

    @Test("a not-found response surfaces 404 error context")
    func notFoundResponseSurfaces404Context() async throws {
        let invalidMovieID = 999_999_999

        var thrownError: TMDbError?
        do {
            _ = try await movieService.details(forMovie: invalidMovieID)
        } catch {
            thrownError = error
        }

        let error = try #require(thrownError)
        guard case .notFound(let context) = error else {
            Issue.record("Expected notFound but got \(error)")
            return
        }

        #expect(context.httpStatusCode == 404)
        #expect(context.tmdbStatusCode == .resourceNotFound)
        #expect(context.statusMessage?.isEmpty == false)
    }

    @Test("an invalid API key surfaces 401 error context")
    func invalidAPIKeySurfaces401Context() async throws {
        let unauthorisedService = TMDbClient(apiKey: "not-a-valid-api-key").movies

        var thrownError: TMDbError?
        do {
            _ = try await unauthorisedService.details(forMovie: 550)
        } catch {
            thrownError = error
        }

        let error = try #require(thrownError)
        guard case .unauthorised(let context) = error else {
            Issue.record("Expected unauthorised but got \(error)")
            return
        }

        #expect(context.httpStatusCode == 401)
        #expect(context.tmdbStatusCode == .invalidAPIKey)
    }

}
