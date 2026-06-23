//
//  APIConfiguration+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension APIConfiguration {

    /// A sample `APIConfiguration` for use in previews and tests.
    static var sample: APIConfiguration {
        let baseURL = URL(string: "http://image.tmdb.org/t/p/") ?? URL(fileURLWithPath: "/")
        let secureBaseURL = URL(string: "https://image.tmdb.org/t/p/")
            ?? URL(fileURLWithPath: "/")

        return APIConfiguration(
            images: ImagesConfiguration(
                baseURL: baseURL,
                secureBaseURL: secureBaseURL,
                backdropSizes: ["w300", "w780", "w1280", "original"],
                logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
                posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
                profileSizes: ["w45", "w185", "h632", "original"],
                stillSizes: ["w92", "w185", "w300", "original"]
            ),
            changeKeys: ["adult", "air_date", "also_known_as"]
        )
    }

}
