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
