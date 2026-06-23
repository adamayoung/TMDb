//
//  NaturalLanguageSearchResult+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension NaturalLanguageSearchResult {

    /// A sample `NaturalLanguageSearchResult` populated with representative data.
    static var sample: NaturalLanguageSearchResult {
        NaturalLanguageSearchResult(
            interpretation: "Movies about space exploration",
            movies: [],
            tvSeries: [],
            people: [],
            degradations: []
        )
    }

}
