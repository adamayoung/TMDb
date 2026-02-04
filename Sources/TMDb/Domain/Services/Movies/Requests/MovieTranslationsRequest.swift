//
//  MovieTranslationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieTranslationsRequest: DecodableAPIRequest<TranslationCollection<MovieTranslationData>> {

    init(id: Movie.ID) {
        let path = "/movie/\(id)/translations"

        super.init(path: path)
    }

}
