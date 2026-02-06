//
//  CreditIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.credit),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct CreditIntegrationTests {

    var creditService: (any CreditService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.creditService = TMDbClient(
            apiKey: apiKey
        ).credits
    }

    @Test("details")
    func details() async throws {
        let creditID = "52542282760ee313280017f9"

        let credit = try await creditService.details(
            forCredit: creditID
        )

        #expect(credit.id == creditID)
        #expect(credit.creditType == .cast)
        #expect(credit.department == "Acting")
        #expect(credit.person.name == "Bryan Cranston")
    }

}
