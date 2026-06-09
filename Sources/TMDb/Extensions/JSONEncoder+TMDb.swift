//
//  JSONEncoder+TMDb.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension JSONEncoder {

    static var theMovieDatabase: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(.theMovieDatabase)
        return encoder
    }

    static var theMovieDatabaseAuth: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(.theMovieDatabaseAuth)
        return encoder
    }

}
