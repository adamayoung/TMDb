//
//  TVSeasonExternalLinksRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonExternalLinksRequest:
DecodableAPIRequest<TVSeasonExternalLinksCollection> {

    init(seasonNumber: Int, tvSeriesID: TVSeries.ID) {
        let path =
            "/tv/\(tvSeriesID)/season/\(seasonNumber)/external_ids"

        super.init(path: path)
    }

}
