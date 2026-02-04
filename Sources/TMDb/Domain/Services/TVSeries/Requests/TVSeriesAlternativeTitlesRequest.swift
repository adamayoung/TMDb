//
//  TVSeriesAlternativeTitlesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesAlternativeTitlesRequest: DecodableAPIRequest<AlternativeTitleCollection> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/alternative_titles"

        super.init(path: path)
    }

}
