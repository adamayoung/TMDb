//
//  DeleteV4AccessTokenRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DeleteV4AccessTokenRequest: CodableAPIRequest<
    DeleteV4AccessTokenRequest.Body, SuccessResult
> {

    init(accessToken: String) {
        let path = "/auth/access_token"
        let body = DeleteV4AccessTokenRequest.Body(accessToken: accessToken)

        super.init(path: path, method: .delete, body: body)
    }

}

extension DeleteV4AccessTokenRequest {

    struct Body: Encodable, Equatable {

        let accessToken: String

    }

}
