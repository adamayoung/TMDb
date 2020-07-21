//
//  DiscoverTVShowsService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol DiscoverTVShowsService {

    func fetchDiscover(page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

}

extension DiscoverTVShowsService {

    public func fetchDiscover(page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        fetchDiscover(page: page)
    }

}
