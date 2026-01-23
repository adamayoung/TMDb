//
//  TVSeriesExternalLinksRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesExternalLinksRequest: DecodableAPIRequest<TVSeriesExternalLinksCollection> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/external_ids"

        super.init(path: path)
    }

}
