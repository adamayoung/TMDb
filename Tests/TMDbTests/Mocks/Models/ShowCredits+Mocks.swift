//
//  ShowCredits+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ShowCredits {

    static func mock(
        id: Int = 1,
        cast: [CastMember] = .mocks,
        crew: [CrewMember] = .mocks
    ) -> ShowCredits {
        ShowCredits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
