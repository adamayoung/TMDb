//
//  PersonDetailsAppendRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonDetailsAppendRequest:
DecodableAPIRequest<PersonDetailsResponse> {

    init(
        id: Person.ID,
        appendToResponse: PersonAppendOption,
        language: String? = nil
    ) {
        let path = "/person/\(id)"
        let queryItems = APIRequestQueryItems(
            appendToResponse: appendToResponse,
            language: language
        )

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(
        appendToResponse: PersonAppendOption,
        language: String?
    ) {
        self.init()

        self[.appendToResponse] = appendToResponse.queryValue

        if let language {
            self[.language] = language
        }
    }

}
