//
//  PersonTVSeriesCredits+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension PersonTVSeriesCredits {

    static func mock(
        id: Int = .randomID,
        cast: [TVSeries] = .mocks,
        crew: [TVSeries] = .mocks
    ) -> Self {
        .init(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
