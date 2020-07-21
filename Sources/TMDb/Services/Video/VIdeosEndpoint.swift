//
//  Endpoint.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

enum VideosEndpoint {

    case movieVideos(movieID: Int)
    case tvShowVideos(tvShowID: Int)
    case tvShowSeasonVideos(tvShowID: Int, seasonNumber: Int)

}

extension VideosEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .movieVideos(let movieID):
            return URL(string: "/movie/\(movieID)/videos")!

        case .tvShowVideos(let tvShowID):
            return URL(string: "/tv/\(tvShowID)/videos")!

        case .tvShowSeasonVideos(let tvShowID, let seasonNumber):
            return URL(string: "/tv/\(tvShowID)/season/\(seasonNumber)/videos")!
        }
    }

}
