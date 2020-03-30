//
//  JSONDecoder+TMDb.swift
//  TMDbClient
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

extension JSONDecoder {

  public static var theMovieDatabase: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-ddd"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)

    return decoder
  }

}
