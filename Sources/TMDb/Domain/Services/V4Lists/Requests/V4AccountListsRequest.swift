//
//  V4AccountListsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class V4AccountListsRequest: DecodableAPIRequest<PageableListResult<V4ListSummary>> {

    init(accountObjectID: String, page: Int? = nil, accessToken: String) {
        // The account object id is caller-supplied and goes into a path
        // segment, where `URLComponents` does no escaping for us (ADR-0008).
        let path = "/account/\(accountObjectID.urlPathSegmentEncoded)/lists"
        let queryItems = APIRequestQueryItems(page: page)

        super.init(
            path: path,
            queryItems: queryItems,
            headers: .v4Authorization(accessToken)
        )
    }

}

private extension APIRequestQueryItems {

    init(page: Int?) {
        self.init()

        self[ifPresent: .page] = page
    }

}
