//
//  TVEpisodeTranslationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVEpisodeTranslationsRequest:
DecodableAPIRequest<TranslationCollection<TVEpisodeTranslationData>> {

    init(
        episodeNumber: Int,
        seasonNumber: Int,
        tvSeriesID: TVSeries.ID
    ) {
        let path = "/tv/\(tvSeriesID)"
            + "/season/\(seasonNumber)"
            + "/episode/\(episodeNumber)/translations"

        super.init(path: path)
    }

}
