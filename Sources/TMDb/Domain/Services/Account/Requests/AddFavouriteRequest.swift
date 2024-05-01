//
//  AddFavouriteRequest.swift
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

final class AddFavouriteRequest: CodableAPIRequest<AddFavouriteRequest.Body, SuccessResult> {

    convenience init(showType: ShowType, showID: Show.ID, isFavourite: Bool, accountID: Int, sessionID: String) {
        let body = AddFavouriteRequest.Body(showType: showType, showID: showID, isFavourite: isFavourite)

        self.init(body: body, accountID: accountID, sessionID: sessionID)
    }

    private init(body: AddFavouriteRequest.Body, accountID: Int, sessionID: String) {
        let path = "/account/\(accountID)/favorite"
        let queryItems = APIRequestQueryItems(sessionID: sessionID)

        super.init(path: path, queryItems: queryItems, body: body)
    }

}

extension AddFavouriteRequest {

    struct Body: Encodable, Equatable {

        let showType: ShowType
        let showID: Show.ID
        let isFavourite: Bool

    }

}

extension AddFavouriteRequest.Body {

    private enum CodingKeys: String, CodingKey {
        case showType = "mediaType"
        case showID = "mediaId"
        case isFavourite = "favorite"
    }

}

private extension APIRequestQueryItems {

    init(sessionID: String) {
        self.init()

        self[.sessionID] = sessionID
    }

}
