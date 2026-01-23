//
//  DeleteSessionRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class DeleteSessionRequest: CodableAPIRequest<DeleteSessionRequest.Body, SuccessResult> {

    init(sessionID: String) {
        let path = "/authentication/session"
        let body = DeleteSessionRequest.Body(sessionID: sessionID)

        super.init(path: path, method: .delete, body: body)
    }

}

extension DeleteSessionRequest {

    struct Body: Encodable, Equatable {

        let sessionID: String

    }

}

extension DeleteSessionRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
    }

}
