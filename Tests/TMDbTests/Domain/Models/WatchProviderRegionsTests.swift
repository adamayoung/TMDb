//
//  WatchProviderRegionsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct WatchProviderRegionsTests {

    @Test("JSON decoding of WatchProviderRegions", .tags(.decoding))
    func decodeReturnsWatchProviderRegions() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            WatchProviderRegions.self,
            fromResource: "watch-provider-regions"
        )

        #expect(result.results == watchProviderRegions.results)
    }

    private let watchProviderRegions = WatchProviderRegions(
        results: [
            Country(countryCode: "AR", name: "Argentina", englishName: "Argentina"),
            Country(countryCode: "AT", name: "Austria", englishName: "Austria"),
            Country(
                countryCode: "US", name: "United States", englishName: "United States of America"
            )
        ]
    )

}
