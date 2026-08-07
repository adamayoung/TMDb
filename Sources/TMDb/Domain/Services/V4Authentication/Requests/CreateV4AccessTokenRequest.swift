//
//  CreateV4AccessTokenRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateV4AccessTokenRequest: CodableAPIRequest<
    CreateV4AccessTokenRequest.Body, V4AccessToken
> {

    init(requestToken: String) {
        let path = "/auth/access_token"
        let body = CreateV4AccessTokenRequest.Body(requestToken: requestToken)

        super.init(path: path, body: body)
    }

}

extension CreateV4AccessTokenRequest {

    struct Body: Encodable, Equatable {

        let requestToken: String

    }

}
