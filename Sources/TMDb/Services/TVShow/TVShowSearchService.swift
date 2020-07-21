//
//  TVShowSearchService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowSearchService {

    func search(query: String, firstAirDateYear: Int?, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

}

extension TVShowSearchService {

    public func search(query: String, firstAirDateYear: Int? = nil, page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        search(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

}
