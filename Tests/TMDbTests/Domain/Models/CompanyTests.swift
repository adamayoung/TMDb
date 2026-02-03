//
//  CompanyTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CompanyTests {

    @Test("JSON decoding of Company", .tags(.decoding))
    func decodeCompany() throws {
        let company = try Company(
            id: 3,
            name: "Pixar",
            description: "",
            headquarters: "Emeryville, California",
            homepageURL: URL(string: "http://www.pixar.com"),
            logoPath: #require(URL(string: "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png")),
            originCountry: "US",
            parentCompany: Company.Parent(
                id: 2,
                name: "Walt Disney Pictures",
                logoPath: #require(URL(string: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png"))
            )
        )

        let result = try JSONDecoder.theMovieDatabase.decode(Company.self, fromResource: "company")

        #expect(result.id == company.id)
        #expect(result.name == company.name)
        #expect(result.description == company.description)
        #expect(result.headquarters == company.headquarters)
        #expect(result.homepageURL == company.homepageURL)
        #expect(result.logoPath == company.logoPath)
        #expect(result.originCountry == company.originCountry)
        let parentCompany = try #require(result.parentCompany)
        #expect(parentCompany.id == company.parentCompany?.id)
        #expect(parentCompany.name == company.parentCompany?.name)
        #expect(parentCompany.logoPath == company.parentCompany?.logoPath)
    }

}
