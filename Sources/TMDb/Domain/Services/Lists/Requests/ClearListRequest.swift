//
//  ClearListRequest.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

final class ClearListRequest: CodableAPIRequest<ClearListRequest.Body, SuccessResult> {

    convenience init(listID: Int, sessionID: String) {
        let body = ClearListRequest.Body(confirm: true)

        self.init(body: body, listID: listID, sessionID: sessionID)
    }

    private init(body: ClearListRequest.Body, listID: Int, sessionID: String) {
        let path = "/list/\(listID)/clear"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension ClearListRequest {

    struct Body: Encodable, Equatable {

        let confirm: Bool

    }

}
