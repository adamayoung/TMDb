//
//  MovieChangesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieChangesRequest: DecodableAPIRequest<ChangeCollection> {

    init(id: Movie.ID, startDate: Date? = nil, endDate: Date? = nil, page: Int? = nil) {
        let path = "/movie/\(id)/changes"
        let queryItems = APIRequestQueryItems(startDate: startDate, endDate: endDate, page: page)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(startDate: Date?, endDate: Date?, page: Int?) {
        self.init()

        self[ifPresent: .startDate] = startDate

        self[ifPresent: .endDate] = endDate

        self[ifPresent: .page] = page
    }

}
