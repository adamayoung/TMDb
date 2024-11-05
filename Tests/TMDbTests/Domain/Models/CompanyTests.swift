//
//  CompanyTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CompanyTests {

    @Test("JSON decoding of Company", .tags(.decoding))
    func decodeCompany() throws {
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

    private let company = Company(
        id: 3,
        name: "Pixar",
        description: "",
        headquarters: "Emeryville, California",
        homepageURL: URL(string: "http://www.pixar.com")!,
        logoPath: URL(string: "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png")!,
        originCountry: "US",
        parentCompany: Company.Parent(
            id: 2,
            name: "Walt Disney Pictures",
            logoPath: URL(string: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png")!
        )
    )

}
