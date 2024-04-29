//
//  DeleteSessionRequest.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

final class DeleteSessionRequest: CodableAPIRequest<DeleteSessionRequest.Body, SuccessResult> {

    init(sessionID: String) {
        let path = "/authentication/session"
        let body = DeleteSessionRequest.Body(sessionID: sessionID)
        let serialiser = TMDbAuthJSONSerialiser()

        super.init(path: path, method: .delete, body: body, serialiser: serialiser)
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
