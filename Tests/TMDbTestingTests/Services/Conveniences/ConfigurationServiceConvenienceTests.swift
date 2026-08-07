//
//  ConfigurationServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``ConfigurationService``.
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
@Suite(.tags(.testingSupport, .mocks, .configuration))
struct ConfigurationServiceConvenienceTests {

    var service: MockConfigurationService

    init() {
        self.service = MockConfigurationService()
    }

    @Test("countries() forwards a nil language to the requirement")
    func countriesForwardsNilLanguage() async throws {
        _ = try await service.countries()

        #expect(service.countriesCalls.count == 1)
        let call = try #require(service.countriesCalls.first)
        #expect(call.language == nil)
    }

}
