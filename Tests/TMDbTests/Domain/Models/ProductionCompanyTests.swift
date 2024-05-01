//
//  ProductionCompanyTests.swift
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

final class ProductionCompanyTests: XCTestCase {

    func testDecodeReturnsProductionCompany() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(ProductionCompany.self, fromResource: "production-company")

        XCTAssertEqual(result.id, productionCompany.id)
        XCTAssertEqual(result.name, productionCompany.name)
        XCTAssertEqual(result.originCountry, productionCompany.originCountry)
        XCTAssertEqual(result.logoPath, productionCompany.logoPath)
    }

    private let productionCompany = ProductionCompany(
        id: 25,
        name: "20th Century Fox",
        originCountry: "US",
        logoPath: URL(string: "/qZCc1lty5FzX30aOCVRBLzaVmcp.png")
    )

}
