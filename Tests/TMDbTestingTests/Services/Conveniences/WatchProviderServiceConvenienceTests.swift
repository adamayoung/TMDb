//
//  WatchProviderServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``WatchProviderService``.
///
/// Each convenience drops its parameters rather than defaulting them, so that
/// its signature cannot witness the requirement it forwards to. These tests
/// assert the other half of that contract: the convenience still reaches the
/// requirement, passing each omitted parameter's default.
///
/// Where a requirement has more than one droppable parameter there is one
/// overload per proper subset of them, and one test per *site* drives the whole
/// set: it calls every overload in turn and walks the mock's recorded calls. A
/// test per overload would assert the same thing several times over, since the
/// mock records every call into one array.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks, .watchProvider))
struct WatchProviderServiceConvenienceTests {

    var service: MockWatchProviderService

    init() {
        self.service = MockWatchProviderService()
    }

    @Test("countries() forwards a nil language to the requirement")
    func countriesForwardsNilLanguage() async throws {
        _ = try await service.countries()

        #expect(service.countriesCalls.count == 1)
        let call = try #require(service.countriesCalls.first)
        #expect(call.language == nil)
    }

    @Test("every movieWatchProviders overload forwards the parameters it omits")
    func movieWatchProvidersOverloadsForwardOmittedParameters() async throws {
        _ = try await service.movieWatchProviders(filter: WatchProviderFilter(country: "GB"))
        _ = try await service.movieWatchProviders(language: "en-GB")
        _ = try await service.movieWatchProviders()

        let calls = service.movieWatchProvidersCalls
        try #require(calls.count == 3)

        #expect(calls[0].filter?.country == "GB")
        #expect(calls[0].language == nil)

        #expect(calls[1].filter == nil)
        #expect(calls[1].language == "en-GB")

        #expect(calls[2].filter == nil)
        #expect(calls[2].language == nil)
    }

    @Test("every tvSeriesWatchProviders overload forwards the parameters it omits")
    func tvSeriesWatchProvidersOverloadsForwardOmittedParameters() async throws {
        _ = try await service.tvSeriesWatchProviders(filter: WatchProviderFilter(country: "GB"))
        _ = try await service.tvSeriesWatchProviders(language: "en-GB")
        _ = try await service.tvSeriesWatchProviders()

        let calls = service.tvSeriesWatchProvidersCalls
        try #require(calls.count == 3)

        #expect(calls[0].filter?.country == "GB")
        #expect(calls[0].language == nil)

        #expect(calls[1].filter == nil)
        #expect(calls[1].language == "en-GB")

        #expect(calls[2].filter == nil)
        #expect(calls[2].language == nil)
    }

}
