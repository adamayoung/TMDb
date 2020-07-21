//
//  TVShowReviewService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowReviewService {

    func fetch(forTVShow tvShowID: Int, page: Int?) -> AnyPublisher<ReviewPageableListResult, TMDbError>

}

extension TVShowReviewService {

    public func fetch(forTVShow tvShowID: Int, page: Int? = nil) -> AnyPublisher<ReviewPageableListResult, TMDbError> {
        fetch(forTVShow: tvShowID, page: page)
    }

}
