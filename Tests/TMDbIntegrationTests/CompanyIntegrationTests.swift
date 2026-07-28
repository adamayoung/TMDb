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
    .integrationGate,
    .serialized,
    .tags(.company),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct CompanyIntegrationTests {

    var companyService: (any CompanyService)!

    init() {
        self.companyService = CredentialHelper.shared.makeClient().companies
    }

    @Test("details")
    func details() async throws {
        let companyID = 82968

        let company = try await companyService.details(forCompany: companyID)

        #expect(company.id == companyID)
        #expect(company.name == "LuckyChap Entertainment")
    }

    @Test("details for a company with no logo")
    func detailsForCompanyWithoutLogo() async throws {
        // Time Warner — TMDb returns null for both logo_path and origin_country.
        // Asserting only that the decode succeeds: whether this company has a
        // logo is contributor-editable live data, so asserting `logoPath == nil`
        // would go red on a data edit rather than on a regression. The nil
        // mapping itself is locked by the fixture-driven unit tests.
        let companyID = 128

        let company = try await companyService.details(forCompany: companyID)

        #expect(company.id == companyID)
        #expect(company.name == "Time Warner")
    }

    @Test("details for a company whose parent has no logo")
    func detailsForCompanyWhoseParentHasNoLogo() async throws {
        // Paramount Pictures — its parent_company (Viacom International) has a
        // null logo_path, which previously made the whole Company decode throw.
        let companyID = 4

        let company = try await companyService.details(forCompany: companyID)

        #expect(company.id == companyID)
        #expect(company.parentCompany != nil)
    }

    @Test("alternativeNames")
    func alternativeNames() async throws {
        let companyID = 82968

        let result = try await companyService.alternativeNames(
            forCompany: companyID
        )

        #expect(result.id == companyID)
    }

    @Test("images")
    func images() async throws {
        let companyID = 82968

        let result = try await companyService.images(forCompany: companyID)

        #expect(result.id == companyID)
    }

}
