//
//  TVShowRecommendationsService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowRecommendationsService {

    func fetchRecommendations(forTVShow tvShowID: Int, page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

}

extension TVShowRecommendationsService {

    public func fetchRecommendations(forTVShow tvShowID: Int, page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        fetchRecommendations(forTVShow: tvShowID, page: page)
    }

}
