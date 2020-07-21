//
//  MultiSearchEndpoint.swift
//  TMDb
//
//  Created by Adam Young on 20/07/2020.
//

import Foundation

enum MultiSearchEndpoint {

    case search(query: String, page: Int?)

}

extension MultiSearchEndpoint: Endpoint {

    var url: URL {
        switch self {

        case .search(let query, let page):
            return URL(string: "/search/multi")!
                .appendingQueryItem(name: "query", value: query)
                .appendingPage(page)
        }
    }

}
