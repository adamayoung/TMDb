//
//  ProductionCompanyTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ProductionCompanyTests {

    @Test("JSON decoding of ProductionCompany", .tags(.decoding))
    func decodeReturnsProductionCompany() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(ProductionCompany.self, fromResource: "production-company")

        #expect(result.id == productionCompany.id)
        #expect(result.name == productionCompany.name)
        #expect(result.originCountry == productionCompany.originCountry)
        #expect(result.logoPath == productionCompany.logoPath)
    }

    private let productionCompany = ProductionCompany(
        id: 25,
        name: "20th Century Fox",
        originCountry: "US",
        logoPath: URL(string: "/qZCc1lty5FzX30aOCVRBLzaVmcp.png")
    )

}
