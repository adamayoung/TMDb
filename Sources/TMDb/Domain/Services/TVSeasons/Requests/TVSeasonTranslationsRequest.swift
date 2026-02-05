//
//  TVSeasonTranslationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeasonTranslationsRequest:
DecodableAPIRequest<TranslationCollection<TVSeasonTranslationData>> {

    init(seasonNumber: Int, tvSeriesID: TVSeries.ID) {
        let path =
            "/tv/\(tvSeriesID)/season/\(seasonNumber)/translations"

        super.init(path: path)
    }

}
