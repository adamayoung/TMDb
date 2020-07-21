//
//  JSONDecoder+TMDb.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

extension JSONDecoder {

    static var theMovieDatabase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(.theMovieDatabase)
        return decoder
    }

}
