//
//  GenreList+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
@testable import TMDb

extension GenreList {

    static func mock(
        genres: [Genre] = .mocks
    ) -> Self {
        .init(
            genres: genres
        )
    }

}
