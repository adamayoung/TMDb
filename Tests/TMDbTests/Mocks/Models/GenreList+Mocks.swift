//
//  GenreList+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension GenreList {

    static func mock(genres: [Genre] = .mocks) -> GenreList {
        GenreList(genres: genres)
    }

}
