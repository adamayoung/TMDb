//
//  ProductionCountryTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

final class ProductionCountryTests: XCTestCase {

    func testIDReturnsISO31661() {
        XCTAssertEqual(productionCountry.id, productionCountry.countryCode)
    }

    func testDecodeReturnsProductionCountry() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(ProductionCountry.self, fromResource: "production-country")

        XCTAssertEqual(result.countryCode, productionCountry.countryCode)
        XCTAssertEqual(result.name, productionCountry.name)
    }

    private let productionCountry = ProductionCountry(
        countryCode: "US",
        name: "United States of America"
    )

}
