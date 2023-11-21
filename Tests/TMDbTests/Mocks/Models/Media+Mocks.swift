//
//  Media+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension Media {

    static func mock() -> Self {
        .movie(.topGunMaverick)
    }

}

extension [Media] {

    static var mocks: [Element] {
        [
            .movie(.bulletTrain),
            .movie(.topGunMaverick),
            .tvSeries(.strangerThings),
            .tvSeries(.theSandman),
            .movie(.jurassicWorldDominion),
            .tvSeries(.sheHulk)
        ]
    }

}
