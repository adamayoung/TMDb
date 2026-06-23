//
//  ScreenedTheatricallyCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension ScreenedTheatricallyCollection {

    /// A sample `ScreenedTheatricallyCollection` populated with representative data.
    static var sample: ScreenedTheatricallyCollection {
        ScreenedTheatricallyCollection(
            id: 1399,
            results: [
                ScreenedTheatricallyResult(id: 63103, episodeNumber: 10, seasonNumber: 4),
                ScreenedTheatricallyResult(id: 63080, episodeNumber: 9, seasonNumber: 3)
            ]
        )
    }

}
