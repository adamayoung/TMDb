//
//  CollectionRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CollectionRequest: DecodableAPIRequest<Collection> {

    init(id: Collection.ID, language: String? = nil) {
        let path = "/collection/\(id)"
        let queryItems = APIRequestQueryItems(language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(language: String?) {
        self.init()

        if let language {
            self[.language] = language
        }
    }

}
