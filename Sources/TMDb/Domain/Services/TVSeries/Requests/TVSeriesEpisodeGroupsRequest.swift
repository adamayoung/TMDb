//
//  TVSeriesEpisodeGroupsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesEpisodeGroupsRequest:
DecodableAPIRequest<TVEpisodeGroupCollection> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/episode_groups"

        super.init(path: path)
    }

}
