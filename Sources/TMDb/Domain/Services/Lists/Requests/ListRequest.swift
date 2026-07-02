//
//  ListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ListRequest: DecodableAPIRequest<MediaList> {

    init(id: Int, page: Int? = nil) {
        let path = "/list/\(id)"
        let queryItems = APIRequestQueryItems(page: page)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?) {
        self.init()

        self[ifPresent: .page] = page
    }

}
