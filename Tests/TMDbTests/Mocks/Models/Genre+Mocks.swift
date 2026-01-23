//
//  Genre+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension Genre {

    static func mock(
        id: Int = 1,
        name: String = "Action"
    ) -> Genre {
        Genre(
            id: id,
            name: name
        )
    }

    static var action: Genre {
        Genre.mock(id: 1, name: "Action")
    }

    static var drama: Genre {
        Genre.mock(id: 1, name: "Drama")
    }

    static var sciFi: Genre {
        Genre.mock(id: 3, name: "Sci-Fi")
    }

}

extension [Genre] {

    static var mocks: [Element] {
        [.action, .drama, .sciFi]
    }

}
