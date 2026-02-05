//
//  PersonChangesListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonChangesListRequest: DecodableAPIRequest<ChangedIDCollection> {

    init(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) {
        let path = "/person/changes"
        let queryItems = APIRequestQueryItems(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    static let startDate = APIRequestQueryItem.Name("start_date")
    static let endDate = APIRequestQueryItem.Name("end_date")

    init(startDate: Date?, endDate: Date?, page: Int?) {
        self.init()

        if let startDate {
            self[Self.startDate] = DateFormatter
                .theMovieDatabase.string(from: startDate)
        }

        if let endDate {
            self[Self.endDate] = DateFormatter
                .theMovieDatabase.string(from: endDate)
        }

        if let page {
            self[.page] = page
        }
    }

}
