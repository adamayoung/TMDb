//
//  CreateV4ListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateV4ListRequest: CodableAPIRequest<CreateV4ListRequest.Body, V4CreateListResult> {

    convenience init(
        name: String,
        description: String? = nil,
        isPublic: Bool? = nil,
        languageCode: String? = nil,
        countryCode: String? = nil,
        sortBy: V4ListSortBy? = nil,
        accessToken: String
    ) {
        let body = CreateV4ListRequest.Body(
            name: name,
            description: description,
            isPublic: isPublic.map { $0 ? 1 : 0 },
            languageCode: languageCode,
            countryCode: countryCode,
            sortBy: sortBy?.description
        )

        self.init(body: body, accessToken: accessToken)
    }

    private init(body: CreateV4ListRequest.Body, accessToken: String) {
        super.init(
            path: "/list",
            body: body,
            headers: .v4Authorization(accessToken)
        )
    }

}

extension CreateV4ListRequest {

    struct Body: Encodable, Equatable {

        let name: String
        let description: String?

        /// Sent as `0`/`1`, **not** as a boolean.
        ///
        /// This was established against the live API: creating with
        /// `{"public": false}` returns a list that reads back as public, while
        /// `{"public": 0}` is honoured. (Update accepts either.)
        let isPublic: Int?

        let languageCode: String?
        let countryCode: String?
        let sortBy: String?

    }

}

extension CreateV4ListRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case isPublic = "public"
        case languageCode = "iso_639_1"
        case countryCode = "iso_3166_1"
        case sortBy = "sort_by"
    }

}
