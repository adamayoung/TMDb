//
//  TVSeasonWatchProvidersRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonWatchProvidersRequest:
DecodableAPIRequest<ShowWatchProviderResult> {

    init(seasonNumber: Int, tvSeriesID: TVSeries.ID) {
        let path =
            "/tv/\(tvSeriesID)/season/\(seasonNumber)/watch/providers"

        super.init(path: path)
    }

}
