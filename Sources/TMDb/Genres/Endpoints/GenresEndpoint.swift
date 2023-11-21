//
//  GenresEndpoint.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

enum GenresEndpoint {

    case movie
    case tvSeries

}

extension GenresEndpoint: Endpoint {

    private static let basePath = URL(string: "/genre")!

    var path: URL {
        switch self {
        case .movie:
            return Self.basePath
                .appendingPathComponent("movie")
                .appendingPathComponent("list")

        case .tvSeries:
            return Self.basePath
                .appendingPathComponent("tv")
                .appendingPathComponent("list")
        }
    }

}
