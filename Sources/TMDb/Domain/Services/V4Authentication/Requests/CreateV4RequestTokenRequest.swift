//
//  CreateV4RequestTokenRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateV4RequestTokenRequest: CodableAPIRequest<
    CreateV4RequestTokenRequest.Body, V4RequestToken
> {

    init(redirectURL: URL? = nil) {
        let path = "/auth/request_token"
        let body = CreateV4RequestTokenRequest.Body(
            redirectTo: redirectURL?.absoluteString
        )

        super.init(path: path, body: body)
    }

}

extension CreateV4RequestTokenRequest {

    struct Body: Encodable, Equatable {

        let redirectTo: String?

    }

}
