//
//  TVSeries+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension TVSeries {

    /// A sample `TVSeries` populated with representative data.
    static var sample: TVSeries {
        TVSeries(
            id: 92783,
            name: "She-Hulk: Attorney at Law",
            overview: "TV Series Overview",
            firstAirDate: Date(timeIntervalSince1970: 1_384_510_800),
            posterPath: URL(string: "/hJfI6AGrmr4uSHRccfJuSsapvOb.jpg")
        )
    }

}
