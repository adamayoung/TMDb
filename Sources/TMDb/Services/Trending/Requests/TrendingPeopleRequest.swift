//
//  File.swift
//
//
//  Created by Adam Young on 16/04/2024.
//

import Foundation

final class TrendingPeopleRequest: DecodableAPIRequest<PersonPageableList> {

    init(timeWindow: TrendingTimeWindowFilterType, page: Int?) {
        let path = "/trending/person/\(timeWindow.rawValue)"
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
