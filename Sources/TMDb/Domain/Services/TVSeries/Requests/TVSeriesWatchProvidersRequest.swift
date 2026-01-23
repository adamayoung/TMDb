//
//  TVSeriesWatchProvidersRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesWatchProvidersRequest: DecodableAPIRequest<ShowWatchProviderResult> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/watch/providers"

        super.init(path: path)
    }

}
