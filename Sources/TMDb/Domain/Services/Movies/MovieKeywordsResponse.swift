//
//  MovieKeywordsResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct MovieKeywordsResponse: Decodable {

    let id: Int
    let keywords: [Keyword]

}

extension MovieKeywordsResponse {

    var keywordCollection: KeywordCollection {
        KeywordCollection(id: id, keywords: keywords)
    }

}
