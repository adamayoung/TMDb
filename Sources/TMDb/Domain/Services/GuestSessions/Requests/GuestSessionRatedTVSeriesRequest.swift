//
//  GuestSessionRatedTVSeriesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class GuestSessionRatedTVSeriesRequest:
DecodableAPIRequest<TVSeriesPageableList> {

    init(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        guestSessionID: String
    ) {
        let path =
            "/guest_session/\(guestSessionID)/rated/tv"
        let queryItems = APIRequestQueryItems(
            sortedBy: sortedBy, page: page
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sortedBy: RatedSort?, page: Int?) {
        self.init()

        if let sortedBy {
            self[.sortBy] = sortedBy
        }

        if let page {
            self[.page] = page
        }
    }

}
