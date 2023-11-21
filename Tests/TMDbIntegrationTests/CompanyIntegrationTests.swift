//
//  CompanyIntegrationTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import TMDb
import XCTest

final class CompanyIntegrationTests: XCTestCase {

    var companyService: CompanyService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        companyService = CompanyService()
    }

    override func tearDown() {
        companyService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let companyID = 82968

        let company = try await companyService.details(forCompany: companyID)

        XCTAssertEqual(company.id, companyID)
        XCTAssertEqual(company.name, "LuckyChap Entertainment")
    }

}
