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
                backdropSizes: ["w300"],
                logoSizes: ["w45"],
                posterSizes: ["w92"],
                profileSizes: ["w45"],
                stillSizes: ["w92"]
            ),
            changeKeys: ["air_date", "also_known_as"]
        )
    }

}
