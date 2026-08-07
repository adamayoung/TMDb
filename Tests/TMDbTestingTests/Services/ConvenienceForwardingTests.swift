//
//  ConvenienceForwardingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on the public service protocols.
///
/// Each convenience drops a parameter rather than defaulting it, so that it
/// cannot serve as its requirement's witness (see the `- Note:` on each). These
/// tests assert the other half of that contract: the convenience still forwards
/// to the requirement, passing `nil` for the parameter it omits.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks))
struct ConvenienceForwardingTests {

    // MARK: - AuthenticationService

    @Test("authenticateURL(for:) forwards a nil redirect URL to the requirement")
    func authenticateURLForwardsNilRedirectURL() throws {
        let service = MockAuthenticationService()

        _ = service.authenticateURL(for: .sample)

        let call = try #require(service.authenticateURLCalls.first)
        #expect(service.authenticateURLCalls.count == 1)
        #expect(call.token == .sample)
        #expect(call.redirectURL == nil)
    }

    @Test("authenticateURL(for:redirectURL:) still reaches the requirement directly")
    func authenticateURLWithRedirectURLReachesRequirement() throws {
        let service = MockAuthenticationService()
        let redirectURL = try #require(URL(string: "https://example.com/done"))

        _ = service.authenticateURL(for: .sample, redirectURL: redirectURL)

        let call = try #require(service.authenticateURLCalls.first)
        #expect(service.authenticateURLCalls.count == 1)
        #expect(call.redirectURL == redirectURL)
    }

}
