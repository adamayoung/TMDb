//
//  UpdateV4ListRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class UpdateV4ListRequest: CodableAPIRequest<UpdateV4ListRequest.Body, SuccessResult> {

    convenience init(
        listID: Int,
        name: String? = nil,
        description: String? = nil,
        isPublic: Bool? = nil,
        sortBy: V4ListSortBy? = nil,
        accessToken: String
    ) {
        let body = UpdateV4ListRequest.Body(
            name: name,
            description: description,
            isPublic: isPublic.map { $0 ? 1 : 0 },
            sortBy: sortBy?.description
        )

        self.init(listID: listID, body: body, accessToken: accessToken)
    }

    private init(listID: Int, body: UpdateV4ListRequest.Body, accessToken: String) {
        super.init(
            path: "/list/\(listID)",
            method: .put,
            body: body,
            headers: .v4Authorization(accessToken)
        )
    }

}

extension UpdateV4ListRequest {

    struct Body: Encodable, Equatable {

        let name: String?
        let description: String?

        /// Sent as `0`/`1` for symmetry with create, which only honours the
        /// integer form. Update accepts either, so this is consistency rather
        /// than necessity.
        let isPublic: Int?

        let sortBy: String?

    }

}

extension UpdateV4ListRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case isPublic = "public"
        case sortBy = "sort_by"
    }

}
