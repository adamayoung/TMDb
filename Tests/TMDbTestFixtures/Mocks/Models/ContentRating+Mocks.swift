//
//  ContentRating+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension ContentRating {

    static func mock(
        descriptors: [String],
        countryCode: String,
        rating: String
    ) -> ContentRating {
        ContentRating(
            descriptors: descriptors,
            countryCode: countryCode,
            rating: rating
        )
    }

    static var parksAndRecreationGB: ContentRating {
        ContentRating.mock(
            descriptors: [],
            countryCode: "GB",
            rating: "15"
        )
    }

    static var parksAndRecreationUS: ContentRating {
        ContentRating.mock(
            descriptors: [],
            countryCode: "GB",
            rating: "TV-14"
        )
    }
}

package extension [ContentRating] {

    static var mocks: [Element] {
        [
            .parksAndRecreationGB,
            .parksAndRecreationUS
        ]
    }

}
