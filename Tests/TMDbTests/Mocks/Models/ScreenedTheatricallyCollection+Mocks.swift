//
//  ScreenedTheatricallyCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ScreenedTheatricallyCollection {

    static func mock(
        id: Int = 1,
        results: [ScreenedTheatricallyResult] = [
            ScreenedTheatricallyResult(id: 1, episodeNumber: 1, seasonNumber: 1),
            ScreenedTheatricallyResult(id: 2, episodeNumber: 2, seasonNumber: 1)
        ]
    ) -> ScreenedTheatricallyCollection {
        ScreenedTheatricallyCollection(
            id: id,
            results: results
        )
    }

}
