//
//  PersonTVSeriesCredits+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension PersonTVSeriesCredits {

    static func mock(
        id: Int = 1,
        cast: [TVSeriesCastCredit] = .mocks,
        crew: [TVSeriesCrewCredit] = .mocks
    ) -> PersonTVSeriesCredits {
        PersonTVSeriesCredits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
