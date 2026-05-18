//
//  GenreIntegrationTests.swift
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
    .tags(.genre),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct GenreIntegrationTests {

    var genreService: (any GenreService)!

    init() {
        self.genreService = CredentialHelper.shared.makeClient().genres
    }

    @Test("movieGenres")
    func movieGenres() async throws {
        let genres = try await genreService.movieGenres()

        #expect(!genres.isEmpty)
    }

    @Test("tvSeriesGenres")
    func tvSeriesGenres() async throws {
        let genres = try await genreService.tvSeriesGenres()

        #expect(!genres.isEmpty)
    }

}
