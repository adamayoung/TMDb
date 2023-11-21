//
//  WatchProviderRegionsTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class WatchProviderRegionsTests: XCTestCase {

    func testDecodeReturnsWatchProviderRegions() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(WatchProviderRegions.self,
                                                             fromResource: "watch-provider-regions")

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
