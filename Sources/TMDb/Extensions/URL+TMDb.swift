//
//  URL+TMDb.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension URL {

    static var tmdbAPIBase: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    static var tmdbWebSite: URL {
        URL(string: "https://www.themoviedb.org")!
    }

}
