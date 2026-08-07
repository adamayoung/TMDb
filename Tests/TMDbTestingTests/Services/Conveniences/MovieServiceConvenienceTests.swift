//
//  MovieServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``MovieService``.
///
/// Each convenience drops a parameter rather than defaulting it, so that its
/// signature cannot witness the requirement it forwards to. These tests assert
/// the other half of that contract: the convenience still reaches the
/// requirement, passing `nil` for the parameter it omits.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks, .movie))
struct MovieServiceConvenienceTests {

    var service: MockMovieService

    init() {
        self.service = MockMovieService()
    }

    @Test("details(forMovie:) forwards a nil language to the requirement")
    func detailsForwardsNilLanguage() async throws {
        _ = try await service.details(forMovie: 550)

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.language == nil)
        #expect(call.movieID == 550)
    }

    @Test("details(forMovie:appending:) forwards a nil language to the requirement")
    func detailsAppendingForwardsNilLanguage() async throws {
        _ = try await service.details(forMovie: 550, appending: .credits)

        #expect(service.detailsAppendingCalls.count == 1)
        let call = try #require(service.detailsAppendingCalls.first)
        #expect(call.language == nil)
        #expect(call.movieID == 550)
        #expect(call.appending == .credits)
    }

    @Test("credits(forMovie:) forwards a nil language to the requirement")
    func creditsForwardsNilLanguage() async throws {
        _ = try await service.credits(forMovie: 550)

        #expect(service.creditsCalls.count == 1)
        let call = try #require(service.creditsCalls.first)
        #expect(call.language == nil)
        #expect(call.movieID == 550)
    }

    @Test("images(forMovie:) forwards a nil filter to the requirement")
    func imagesForwardsNilFilter() async throws {
        _ = try await service.images(forMovie: 550)

        #expect(service.imagesCalls.count == 1)
        let call = try #require(service.imagesCalls.first)
        #expect(call.filter == nil)
        #expect(call.movieID == 550)
    }

    @Test("videos(forMovie:) forwards a nil filter to the requirement")
    func videosForwardsNilFilter() async throws {
        _ = try await service.videos(forMovie: 550)

        #expect(service.videosCalls.count == 1)
        let call = try #require(service.videosCalls.first)
        #expect(call.filter == nil)
        #expect(call.movieID == 550)
    }

}
