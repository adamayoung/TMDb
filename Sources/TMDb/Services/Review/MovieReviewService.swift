//
//  MovieReviewService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieReviewService {

    func fetch(forMovie movieID: Int, page: Int?) -> AnyPublisher<ReviewPageableListResult, TMDbError>

}

extension MovieReviewService {

    public func fetch(forMovie movieID: Int, page: Int? = nil) -> AnyPublisher<ReviewPageableListResult, TMDbError> {
        fetch(forMovie: movieID, page: page)
    }

}
