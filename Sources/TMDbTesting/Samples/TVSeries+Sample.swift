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
            id: 1399,
            name: "Game of Thrones",
            overview: "Seven noble families fight for control of the mythical land of "
                + "Westeros. Friction between the houses leads to full-scale war. All while a "
                + "very ancient evil awakens in the farthest north. Amidst the war, a neglected "
                + "military order of misfits, the Night's Watch, is all that stands between the "
                + "realms of men and icy horrors beyond.",
            firstAirDate: Date(timeIntervalSince1970: 1_302_998_400),
            posterPath: URL(string: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg")
        )
    }

}
