//
//  URL+TMDb.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension URL {

    static var tmdbAPIBase: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "https://api.themoviedb.org/3")!
    }

    static var tmdbWebSite: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "https://www.themoviedb.org")!
    }

}
