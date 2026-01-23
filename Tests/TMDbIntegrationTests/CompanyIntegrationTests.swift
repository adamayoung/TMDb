//
//  CompanyIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.company),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct CompanyIntegrationTests {

    var companyService: (any CompanyService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.companyService = TMDbClient(apiKey: apiKey).companies
    }

    @Test("details")
    func details() async throws {
        let companyID = 82968

        let company = try await companyService.details(forCompany: companyID)

        #expect(company.id == companyID)
        #expect(company.name == "LuckyChap Entertainment")
    }

}
