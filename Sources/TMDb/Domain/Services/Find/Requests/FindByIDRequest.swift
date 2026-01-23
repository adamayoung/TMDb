//
//  FindByIDRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class FindByIDRequest: DecodableAPIRequest<FindResults> {

    init(
        externalID: String,
        externalSource: ExternalSource,
        language: String? = nil
    ) {
        let path = "/find/\(externalID)"
        let queryItems = APIRequestQueryItems(
            externalSource: externalSource,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        externalSource: ExternalSource,
        language: String?
    ) {
        self.init()

        self[.externalSource] = externalSource.rawValue

        if let language {
            self[.language] = language
        }
    }

}
