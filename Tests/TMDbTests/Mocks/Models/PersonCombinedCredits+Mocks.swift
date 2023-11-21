//
//  PersonCombinedCredits+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension PersonCombinedCredits {

    static func mock(
        id: Int = .randomID,
        cast: [Show] = [
            .movie(.jurassicWorldDominion),
            .tvSeries(.theSandman),
            .movie(.topGunMaverick),
            .tvSeries(.sheHulk),
            .tvSeries(.strangerThings)
        ],
        crew: [Show] = [
            .movie(.bulletTrain),
            .tvSeries(.theSandman),
            .movie(.thorLoveAndThunder)
        ]
    ) -> Self {
        .init(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
