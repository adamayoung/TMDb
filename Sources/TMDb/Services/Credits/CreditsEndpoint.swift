//
//  CreditsEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum CreditsEndpoint {

    case movieCredits(movieID: Int)
    case tvShowCredits(tvShowID: Int)

}

extension CreditsEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .movieCredits(let movieID):
            return URL(string: "/movie/\(movieID)/credits")!

        case .tvShowCredits(let tvShowID):
            return URL(string: "/tv/\(tvShowID)/credits")!
        }
    }

}
