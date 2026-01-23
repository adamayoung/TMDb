//
//  MovieVideosRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieVideosRequest: DecodableAPIRequest<VideoCollection> {

    init(id: Movie.ID, languages: [String]? = nil) {
        let path = "/movie/\(id)/videos"
        let queryItems = APIRequestQueryItems(languages: languages)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(languages: [String]?) {
        self.init()

        if let languages {
            self[.includeVideoLanguage] = languages.joined(separator: ",")
        }
    }

}
