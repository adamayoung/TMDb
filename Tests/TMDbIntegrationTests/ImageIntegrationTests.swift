//
//  ImageIntegrationTests.swift
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
    .tags(.images),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ImageIntegrationTests {

    var client: TMDbClient!

    init() throws {
        self.client = CredentialHelper.shared.makeClient()
    }

    @Test("preload")
    func preload() async throws {
        try await client.images.preload()

        let configuration = try await client.images.imagesConfiguration()

        #expect(!configuration.posterSizes.isEmpty)
    }

    @Test("imagesConfiguration")
    func imagesConfiguration() async throws {
        let configuration = try await client.images.imagesConfiguration()

        #expect(!configuration.backdropSizes.isEmpty)
        #expect(!configuration.logoSizes.isEmpty)
        #expect(!configuration.posterSizes.isEmpty)
        #expect(!configuration.profileSizes.isEmpty)
        #expect(!configuration.stillSizes.isEmpty)
        #expect(configuration.secureBaseURL.scheme == "https")
    }

    @Test("posterURL for a movie's poster path")
    func posterURLForMoviePosterPath() async throws {
        let movie = try await client.movies.details(forMovie: 346_698)

        let url = try await client.images.posterURL(for: movie.posterPath, size: .width(500))

        let posterURL = try #require(url)
        #expect(posterURL.scheme == "https")
        #expect(posterURL.absoluteString.contains("/w500/"))
    }

    @Test("posterURL for a nil path returns nil")
    func posterURLForNilPathReturnsNil() async throws {
        let url = try await client.images.posterURL(for: nil, size: .width(500))

        #expect(url == nil)
    }

    @Test("refresh")
    func refresh() async throws {
        let before = try await client.images.imagesConfiguration()

        let refreshed = try await client.images.refresh()

        #expect(!refreshed.posterSizes.isEmpty)
        #expect(refreshed == before)
    }

}
