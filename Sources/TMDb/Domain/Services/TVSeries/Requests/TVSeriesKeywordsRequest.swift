//
//  TVSeriesKeywordsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesKeywordsRequest: DecodableAPIRequest<KeywordCollection> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/keywords"

        super.init(path: path)
    }

}
