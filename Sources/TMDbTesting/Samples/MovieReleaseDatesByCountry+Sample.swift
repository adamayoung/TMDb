//
//  MovieReleaseDatesByCountry+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension MovieReleaseDatesByCountry {

    /// A sample `MovieReleaseDatesByCountry` populated with representative data.
    static var sample: MovieReleaseDatesByCountry {
        MovieReleaseDatesByCountry(
            countryCode: "US",
            releaseDates: [
                ReleaseDate(
                    certification: "R",
                    descriptors: [],
                    languageCode: nil,
                    note: nil,
                    releaseDate: Date(timeIntervalSince1970: 939_945_600),
                    type: .theatrical
                )
            ]
        )
    }

}

public extension [MovieReleaseDatesByCountry] {

    /// A sample array of `MovieReleaseDatesByCountry` populated with representative data.
    static var samples: [MovieReleaseDatesByCountry] {
        [.sample]
    }

}
