//
//  PersonCombinedCredits+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension PersonCombinedCredits {

    static func mock(
        id: Int = 1,
        cast: [ShowCastCredit] = .mocks,
        crew: [ShowCrewCredit] = .mocks
    ) -> PersonCombinedCredits {
        PersonCombinedCredits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
