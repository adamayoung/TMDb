//
//  TVEpisodeGroupRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeGroupRequest:
DecodableAPIRequest<TVEpisodeGroup> {

    init(id: TVEpisodeGroup.ID) {
        let path = "/tv/episode_group/\(id.urlPathSegmentEncoded)"

        super.init(path: path)
    }

}
