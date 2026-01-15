//
//  AddMediaRequest.swift
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

final class AddMediaRequest: CodableAPIRequest<AddMediaRequest.Body, SuccessResult> {

    convenience init(mediaID: Int, listID: Int, sessionID: String) {
        let body = AddMediaRequest.Body(mediaID: mediaID)

        self.init(body: body, listID: listID, sessionID: sessionID)
    }

    private init(body: AddMediaRequest.Body, listID: Int, sessionID: String) {
        let path = "/list/\(listID)/add_item"
        var queryItems = APIRequestQueryItems()
        queryItems[.sessionID] = sessionID

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension AddMediaRequest {

    struct Body: Encodable, Equatable {

        let mediaID: Int

    }

}

extension AddMediaRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case mediaID = "mediaId"
    }

}
