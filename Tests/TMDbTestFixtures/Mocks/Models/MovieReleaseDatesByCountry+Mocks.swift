//
//  MovieReleaseDatesByCountry+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension MovieReleaseDatesByCountry {

    static func mock(
        countryCode: String = "US",
        releaseDates: [ReleaseDate] = [.mock()]
    ) -> MovieReleaseDatesByCountry {
        MovieReleaseDatesByCountry(
            countryCode: countryCode,
            releaseDates: releaseDates
        )
    }

}
