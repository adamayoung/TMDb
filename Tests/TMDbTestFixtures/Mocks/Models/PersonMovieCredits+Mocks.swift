//
//  PersonMovieCredits+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension PersonMovieCredits {

    static func mock(
        id: Int = 1,
        cast: [MovieCastCredit] = .mocks,
        crew: [MovieCrewCredit] = .mocks
    ) -> PersonMovieCredits {
        PersonMovieCredits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
