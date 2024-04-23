//
//  CreateGuestSessionRequest.swift
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

final class ValidateTokenWithLoginRequest: CodableAPIRequest<ValidateTokenWithLoginRequest.Body, Token> {

    init(username: String, password: String, requestToken: String) {
        let path = "/authentication/token/validate_with_login"
        let body = ValidateTokenWithLoginRequest.Body(
            username: username,
            password: password,
            requestToken: requestToken
        )
        let serialiser = TMDbAuthJSONSerialiser()

        super.init(path: path, body: body, serialiser: serialiser)
    }

}

extension ValidateTokenWithLoginRequest {

    struct Body: Encodable, Equatable {

        let username: String
        let password: String
        let requestToken: String

    }

}
