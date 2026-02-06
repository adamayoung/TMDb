//
//  GuestSessionRatedMoviesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class GuestSessionRatedMoviesRequest:
DecodableAPIRequest<MoviePageableList> {

    init(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        guestSessionID: String
    ) {
        let path =
            "/guest_session/\(guestSessionID)/rated/movies"
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
