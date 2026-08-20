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

    static let startDate = APIRequestQueryItem.Name("start_date")
    static let endDate = APIRequestQueryItem.Name("end_date")

    init(startDate: Date?, endDate: Date?, page: Int?) {
        self.init()

        // Format through the shared formatter, as every sibling changes request
        // does. Assigning the `Date` itself would stringify it with
        // `Date.description` — `APIRequestQueryItems` is keyed to
        // `CustomStringConvertible` — sending "2024-01-01 00:00:00 +0000"
        // rather than "2024-01-01", and bypassing the GMT pin the formatter
        // carries.
        if let startDate {
            self[Self.startDate] = DateFormatter.theMovieDatabase.string(from: startDate)
        }

        if let endDate {
            self[Self.endDate] = DateFormatter.theMovieDatabase.string(from: endDate)
        }

        self[ifPresent: .page] = page
    }

}
