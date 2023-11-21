//
//  URL+TMDb.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension URL {

    static var tmdbAPIBaseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

}
