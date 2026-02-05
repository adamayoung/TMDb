//
//  TVEpisodeExternalLinksRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeExternalLinksRequest:
DecodableAPIRequest<TVEpisodeExternalLinksCollection> {

    init(
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeriesID: TVSeries.ID
    ) {
        let path = "/tv/\(tvSeriesID)"
            + "/season/\(seasonNumber)"
            + "/episode/\(episodeNumber)/external_ids"

        super.init(path: path)
    }

}
