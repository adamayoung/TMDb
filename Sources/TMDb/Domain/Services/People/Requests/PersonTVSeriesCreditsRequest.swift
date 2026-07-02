//
//  PersonTVSeriesCreditsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonTVSeriesCreditsRequest: DecodableAPIRequest<PersonTVSeriesCredits> {

    init(id: Person.ID, language: String? = nil) {
        let path = "/person/\(id)/tv_credits"
        let queryItems = APIRequestQueryItems(language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(language: String?) {
        self.init()

        self[ifPresent: .language] = language
    }

}
