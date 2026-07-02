//
//  GuestSessionRatedTVEpisodesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class GuestSessionRatedTVEpisodesRequest:
DecodableAPIRequest<TVEpisodePageableList> {

    init(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        guestSessionID: String
    ) {
        let path =
            "/guest_session/\(guestSessionID)/rated/tv/episodes"
        let queryItems = APIRequestQueryItems(
            sortedBy: sortedBy, page: page
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(sortedBy: RatedSort?, page: Int?) {
        self.init()

        self[ifPresent: .sortBy] = sortedBy

        self[ifPresent: .page] = page
    }

}
