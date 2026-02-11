//
//  CreateSessionFromV4AccessTokenRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateSessionFromV4AccessTokenRequest: CodableAPIRequest<
    CreateSessionFromV4AccessTokenRequest.Body, Session
> {

    init(accessToken: String) {
        let path = "/authentication/session/convert/4"
        let body = CreateSessionFromV4AccessTokenRequest.Body(
            accessToken: accessToken
        )

        super.init(path: path, body: body)
    }

}

extension CreateSessionFromV4AccessTokenRequest {

    struct Body: Encodable, Equatable {

        let accessToken: String

    }

}
