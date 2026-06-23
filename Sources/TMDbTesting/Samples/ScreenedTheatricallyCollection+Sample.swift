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
            id: 1,
            results: [
                ScreenedTheatricallyResult(id: 1, episodeNumber: 1, seasonNumber: 1),
                ScreenedTheatricallyResult(id: 2, episodeNumber: 2, seasonNumber: 1)
            ]
        )
    }

}
