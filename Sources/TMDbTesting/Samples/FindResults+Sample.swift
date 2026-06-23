//
//  FindResults+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension FindResults {

    /// A sample `FindResults` for use in tests and previews.
    static var sample: FindResults {
        FindResults(
            movieResults: [],
            personResults: [],
            tvResults: [],
            tvSeasonResults: [],
            tvEpisodeResults: []
        )
    }

}
