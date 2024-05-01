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

@testable import TMDb
import XCTest

final class CompanyTests: XCTestCase {

    func testDecodeReturnsCompany() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Company.self, fromResource: "company")

        XCTAssertEqual(result.id, company.id)
        XCTAssertEqual(result.name, company.name)
        XCTAssertEqual(result.description, company.description)
        XCTAssertEqual(result.headquarters, company.headquarters)
        XCTAssertEqual(result.homepage, company.homepage)
        XCTAssertEqual(result.logoPath, company.logoPath)
        XCTAssertEqual(result.originCountry, company.originCountry)
        let parentCompany = try XCTUnwrap(result.parentCompany)
        XCTAssertEqual(parentCompany.id, company.parentCompany?.id)
        XCTAssertEqual(parentCompany.name, company.parentCompany?.name)
        XCTAssertEqual(parentCompany.logoPath, company.parentCompany?.logoPath)
    }

    private let company = Company(
        id: 3,
        name: "Pixar",
        description: "",
        headquarters: "Emeryville, California",
        homepage: URL(string: "http://www.pixar.com")!,
        logoPath: URL(string: "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png")!,
        originCountry: "US",
        parentCompany: Company.Parent(
            id: 2,
            name: "Walt Disney Pictures",
            logoPath: URL(string: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png")!
        )
    )

}
