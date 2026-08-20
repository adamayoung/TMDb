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

    static let startDate = APIRequestQueryItem.Name("start_date")
    static let endDate = APIRequestQueryItem.Name("end_date")

    init(startDate: Date?, endDate: Date?, page: Int?) {
        self.init()

        // Format through the shared formatter, as every sibling changes request
        // does — see `MovieChangesRequest` for why assigning the `Date` itself
        // is wrong.
        if let startDate {
            self[Self.startDate] = DateFormatter.theMovieDatabase.string(from: startDate)
        }

        if let endDate {
            self[Self.endDate] = DateFormatter.theMovieDatabase.string(from: endDate)
        }

        self[ifPresent: .page] = page
    }

}
