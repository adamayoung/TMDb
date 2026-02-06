//
//  TrendingItem+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TrendingItem {

    static func mockMovie() -> TrendingItem {
        .movie(.mock())
    }

    static func mockTVSeries() -> TrendingItem {
        .tvSeries(.mock())
    }

    static func mockPerson() -> TrendingItem {
        .person(.mock(originalName: "Person Name"))
    }

}
