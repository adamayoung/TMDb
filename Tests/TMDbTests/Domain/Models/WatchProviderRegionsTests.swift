//
//  WatchProviderRegionsTests.swift
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

final class WatchProviderRegionsTests: XCTestCase {

    func testDecodeReturnsWatchProviderRegions() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            WatchProviderRegions.self,
            fromResource: "watch-provider-regions"
        )

        XCTAssertEqual(result.results, watchProviderRegions.results)
    }

    private let watchProviderRegions = WatchProviderRegions(
        results: [
            Country(countryCode: "AR", name: "Argentina", englishName: "Argentina"),
            Country(countryCode: "AT", name: "Austria", englishName: "Austria"),
            Country(countryCode: "US", name: "United States", englishName: "United States of America")
        ]
    )

}
