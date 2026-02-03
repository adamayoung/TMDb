//
//  MovieReleaseDatesResult+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension MovieReleaseDatesResult {

    static func mock(
        id: Int = 550,
        results: [MovieReleaseDatesByCountry] = [
            .mock(countryCode: "US"), .mock(countryCode: "GB")
        ]
    ) -> MovieReleaseDatesResult {
        MovieReleaseDatesResult(
            id: id,
            results: results
        )
    }

}
