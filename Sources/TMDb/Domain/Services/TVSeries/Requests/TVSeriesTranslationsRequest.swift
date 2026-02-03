//
//  TVSeriesTranslationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesTranslationsRequest:
    DecodableAPIRequest<TranslationCollection<TVSeriesTranslationData>> {

    init(id: TVSeries.ID) {
        let path = "/tv/\(id)/translations"

        super.init(path: path)
    }

}
