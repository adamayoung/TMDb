//
//  Genre+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension Genre {

    ///
    /// A sample genre, for use in tests and previews.
    ///
    static var sample: Genre {
        Genre(id: 28, name: "Action")
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension [Genre] {

    ///
    /// A sample list of genres, for use in tests and previews.
    ///
    static var samples: [Genre] {
        [
            Genre(id: 28, name: "Action"),
            Genre(id: 18, name: "Drama"),
            Genre(id: 878, name: "Science Fiction")
        ]
    }

}
