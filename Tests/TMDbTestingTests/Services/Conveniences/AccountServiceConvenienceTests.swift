//
//  AccountServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``AccountService``.
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
@Suite(.tags(.testingSupport, .mocks, .account))
struct AccountServiceConvenienceTests {

    var service: MockAccountService

    init() {
        self.service = MockAccountService()
    }

    @Test("lists(accountID:session:) forwards a nil page to the requirement")
    func listsForwardsNilPage() async throws {
        _ = try await service.lists(accountID: 42, session: .sample)

        #expect(service.listsCalls.count == 1)
        let call = try #require(service.listsCalls.first)
        #expect(call.page == nil)
        #expect(call.accountID == 42)
        #expect(call.session == .sample)
    }

}
