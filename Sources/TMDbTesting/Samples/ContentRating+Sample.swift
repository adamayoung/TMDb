//
//  ContentRating+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension ContentRating {

    ///
    /// A sample content rating, for use in tests and previews.
    ///
    static var sample: ContentRating {
        ContentRating(
            descriptors: [],
            countryCode: "GB",
            rating: "18"
        )
    }

}

public extension [ContentRating] {

    ///
    /// A sample list of content ratings, for use in tests and previews.
    ///
    static var samples: [ContentRating] {
        [
            ContentRating(descriptors: [], countryCode: "GB", rating: "18"),
            ContentRating(descriptors: [], countryCode: "US", rating: "TV-MA")
        ]
    }

}
