//
//  ValidateTokenWithLoginRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ValidateTokenWithLoginRequest: CodableAPIRequest<
    ValidateTokenWithLoginRequest.Body, Token
> {

    init(username: String, password: String, requestToken: String) {
        let path = "/authentication/token/validate_with_login"
        let body = ValidateTokenWithLoginRequest.Body(
            username: username,
            password: password,
            requestToken: requestToken
        )

        super.init(path: path, body: body)
    }

}

extension ValidateTokenWithLoginRequest {

    struct Body: Encodable, Equatable {

        let username: String
        let password: String
        let requestToken: String

    }

}
