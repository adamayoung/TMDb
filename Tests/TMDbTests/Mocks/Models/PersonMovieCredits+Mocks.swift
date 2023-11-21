//
//  PersonMovieCredits+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension PersonMovieCredits {

    static func mock(
        id: Int = .randomID,
        cast: [Movie] = .mocks,
        crew: [Movie] = .mocks
    ) -> Self {
        .init(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
