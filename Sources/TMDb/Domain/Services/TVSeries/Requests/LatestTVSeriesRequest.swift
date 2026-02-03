//
//  LatestTVSeriesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class LatestTVSeriesRequest: DecodableAPIRequest<TVSeries> {

    init() {
        let path = "/tv/latest"

        super.init(path: path)
    }

}
