//
//  SearchPlan+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension SearchPlan {

    /// A sample `SearchPlan` for use in tests and previews.
    static var sample: SearchPlan {
        SearchPlan(
            intent: .find,
            isInScope: true,
            mediaType: .movie,
            title: "Star Wars",
            people: [],
            crewRole: nil,
            genres: [],
            excludeTitles: [],
            companies: [],
            moodTerm: nil,
            date: nil,
            runtimeMaxMinutes: nil,
            minRating: nil,
            list: nil
        )
    }

}
