//
//  PersonSearchService.swift
//  TMDb
//
//  Created by Adam Young on 20/07/2020.
//

import Combine
import Foundation

public protocol PersonSearchService {

    func search(query: String, page: Int?) -> AnyPublisher<PersonPageableListResult, TMDbError>

}

extension PersonSearchService {

    public func search(query: String, page: Int? = nil) -> AnyPublisher<PersonPageableListResult, TMDbError> {
        search(query: query, page: page)
    }

}
