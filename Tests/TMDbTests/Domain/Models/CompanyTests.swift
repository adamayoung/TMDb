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
        let company = Company(
            id: 3,
            name: "Pixar",
            description: "",
            headquarters: "Emeryville, California",
            homepageURL: URL(string: "http://www.pixar.com"),
            logoPath: URL(string: "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png"),
            originCountry: "US",
            parentCompany: Company.Parent(
                id: 2,
                name: "Walt Disney Pictures",
                logoPath: URL(string: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png")
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

    @Test("JSON decoding of Company when logo path and origin country are null", .tags(.decoding))
    func decodeCompanyWhenLogoPathAndOriginCountryAreNull() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Company.self,
            fromResource: "company-null-logo"
        )

        #expect(result.id == 128)
        #expect(result.name == "Time Warner")
        #expect(result.logoPath == nil)
        #expect(result.originCountry == nil)
        #expect(result.parentCompany == nil)
    }

    @Test("JSON decoding of Company when logo path is an empty string", .tags(.decoding))
    func decodeCompanyWhenLogoPathIsEmptyString() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Company.self,
            fromResource: "company-empty-logo"
        )

        #expect(result.logoPath == nil)
    }

    @Test("JSON decoding of Company when parent company's logo path is null", .tags(.decoding))
    func decodeCompanyWhenParentCompanyLogoPathIsNull() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Company.self,
            fromResource: "company-null-parent-logo"
        )

        #expect(result.logoPath != nil)
        #expect(result.originCountry == "US")
        let parentCompany = try #require(result.parentCompany)
        #expect(parentCompany.id == 5308)
        #expect(parentCompany.name == "Viacom International")
        #expect(parentCompany.logoPath == nil)
    }

    @Test(
        "JSON decoding of Company when parent company's logo path is an empty string",
        .tags(.decoding)
    )
    func decodeCompanyWhenParentCompanyLogoPathIsEmptyString() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Company.self,
            fromResource: "company-empty-parent-logo"
        )

        let parentCompany = try #require(result.parentCompany)
        #expect(parentCompany.logoPath == nil)
    }

    @Test(
        "JSON decoding of Company when the logo path keys are absent",
        .tags(.decoding)
    )
    func decodeCompanyWhenLogoPathKeysAreAbsent() throws {
        // TMDb always sends these keys, so this covers the decoder's
        // key-absent branch defensively rather than a shape seen in the wild.
        let result = try JSONDecoder.theMovieDatabase.decode(
            Company.self,
            fromResource: "company-absent-logo"
        )

        #expect(result.logoPath == nil)
        #expect(result.originCountry == nil)
        let parentCompany = try #require(result.parentCompany)
        #expect(parentCompany.logoPath == nil)
    }

    @Test(
        "JSON encoding of Company round-trips",
        .tags(.encoding),
        arguments: [
            "company",
            "company-null-logo",
            "company-null-parent-logo",
            "company-empty-logo",
            "company-empty-parent-logo",
            "company-absent-logo"
        ]
    )
    func encodeCompanyRoundTrips(resource: String) throws {
        let decoded = try JSONDecoder.theMovieDatabase.decode(
            Company.self,
            fromResource: resource
        )

        let data = try JSONEncoder.theMovieDatabase.encode(decoded)
        let roundTripped = try JSONDecoder.theMovieDatabase.decode(Company.self, from: data)

        #expect(roundTripped == decoded)
    }

}
