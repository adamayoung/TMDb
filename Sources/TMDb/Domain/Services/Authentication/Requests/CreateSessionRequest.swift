//
//  CreateSessionRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CreateSessionRequest: CodableAPIRequest<CreateSessionRequest.Body, Session> {

    init(requestToken: String) {
        let path = "/authentication/session/new"
        let body = CreateSessionRequest.Body(requestToken: requestToken)

        super.init(path: path, body: body)
    }

}

extension CreateSessionRequest {

    struct Body: Encodable, Equatable {

        let requestToken: String

    }

}
