//
//  MultiSearchService.swift
//  TMDb
//
//  Created by Adam Young on 20/07/2020.
//

import Combine
import Foundation

public protocol MultiSearchService {

    func search(query: String, page: Int?) -> AnyPublisher<MultiTypePageableListResult, TMDbError>

}

extension MultiSearchService {

    public func search(query: String, page: Int? = nil) -> AnyPublisher<MultiTypePageableListResult, TMDbError> {
        search(query: query, page: page)
    }

}
