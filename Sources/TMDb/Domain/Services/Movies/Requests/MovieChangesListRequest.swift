//
//  MovieChangesListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieChangesListRequest: DecodableAPIRequest<ChangedIDCollection> {

    init(startDate: Date? = nil, endDate: Date? = nil, page: Int? = nil) {
        let path = "/movie/changes"
        let queryItems = APIRequestQueryItems(startDate: startDate, endDate: endDate, page: page)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(startDate: Date?, endDate: Date?, page: Int?) {
        self.init()

        if let startDate {
            self[.startDate] = startDate
        }

        if let endDate {
            self[.endDate] = endDate
        }

        if let page {
            self[.page] = page
        }
    }

}
