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

    @Test("posterURL for an ideal width selects a sized variant from the live configuration")
    func posterURLForIdealWidthSelectsSizedVariant() async throws {
        let movie = try await client.movies.details(forMovie: 346_698)

        let url = try await client.images.posterURL(for: movie.posterPath, idealWidth: 300)

        // Exercises a different path from the `size:` family: this one parses the
        // live size strings ("w500", "h632", "original") to pick the smallest
        // that is at least this wide. A TMDb-side format change would break it
        // silently, which is what this suite exists to catch.
        let posterURL = try #require(url)
        #expect(posterURL.scheme == "https")
        #expect(!posterURL.absoluteString.contains("/original/"))
    }

    @Test("profileURL for an ideal width resolves against the live configuration")
    func profileURLForIdealWidthResolvesAgainstLiveConfiguration() async throws {
        let person = try await client.people.details(forPerson: 287)

        let url = try await client.images.profileURL(for: person.profilePath, idealWidth: 200)

        let profileURL = try #require(url)
        #expect(profileURL.scheme == "https")
    }

    @Test("posterURL for a nil path returns nil")
    func posterURLForNilPathReturnsNil() async throws {
        let url = try await client.images.posterURL(for: nil, size: .width(500))

        #expect(url == nil)
    }

    @Test("refresh")
    func refresh() async throws {
        _ = try await client.images.imagesConfiguration()

        let refreshed = try await client.images.refresh()

        // Assert the refresh returned a usable configuration, not that it equals
        // the previous one: that would be a weak assertion (it holds trivially
        // for a static endpoint) and would break if TMDb ever changed the
        // configuration between the two calls.
        #expect(!refreshed.posterSizes.isEmpty)
        #expect(!refreshed.profileSizes.isEmpty)
        #expect(refreshed.secureBaseURL.scheme == "https")

        // The refreshed value must be what later resolutions use.
        let after = try await client.images.imagesConfiguration()
        #expect(after == refreshed)
    }

}
