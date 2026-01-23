//
//  ContentRatingRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ContentRatingRequest: DecodableAPIRequest<ContentRatingResult> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/content_ratings"

        super.init(path: path)
    }

}
