//
//  Media+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension Media {

    static func mock() -> Media {
        Media.movie(.topGunMaverick)
    }

}

package extension [Media] {

    static var mocks: [Element] {
        [
            .movie(.bulletTrain),
            .movie(.topGunMaverick),
            .tvSeries(.bigBrother),
            .tvSeries(.csi),
            .movie(.jurassicWorldDominion)
        ]
    }

}
