//
//  File.swift
//  
//
//  Created by Adam Young on 16/04/2024.
//

import Foundation

final class TrendingMoviesRequest: DecodableAPIRequest<MoviePageableList> {

    init(timeWindow: TrendingTimeWindowFilterType, page: Int?) {
        let path = "/trending/movie/\(timeWindow.rawValue)"
        let queryItems = APIRequestQueryItems(page: page)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    private enum QueryItemName {
        static let page = "page"
    }

    init(page: Int?) {
        self.init()

        if let page {
            self[QueryItemName.page] = "\(page)"
        }
    }

}
