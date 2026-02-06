//
//  TVSeriesScreenedTheatricallyRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesScreenedTheatricallyRequest:
DecodableAPIRequest<ScreenedTheatricallyCollection> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/screened_theatrically"

        super.init(path: path)
    }

}
