//
//  ReviewsEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum ReviewsEndpoint {

    case movieReviews(movieID: Int, page: Int?)
    case tvShowReviews(tvShowID: Int, page: Int?)

}

extension ReviewsEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .movieReviews(let movieID, let page):
            return URL(string: "/movie/\(movieID)/reviews")!
                .appendingPage(page)

        case .tvShowReviews(let tvShowID, let page):
            return URL(string: "/tv/\(tvShowID)/reviews")!
                .appendingPage(page)
        }
    }

}
