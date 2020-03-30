//
//  TVShowSearchService.swift
//  TMDbTVShows
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowSearchService {

  func search(query: String, firstAirDateYear: Int?, page: Int?) -> AnyPublisher<TVShowPageableListResult, Error>

}

extension TVShowSearchService {

  public func search(query: String, firstAirDateYear: Int? = nil,
                     page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, Error> {
    search(query: query, firstAirDateYear: firstAirDateYear, page: page)
  }

}
