//
//  File.swift
//  
//
//  Created by Adam Young on 08/03/2024.
//

import Foundation

struct AddFavouriteRequestBody: Encodable, Equatable {

    let showType: ShowType
    let showID: Show.ID
    let isFavourite: Bool

}

extension AddFavouriteRequestBody {

    private enum CodingKeys: String, CodingKey {
        case showType = "mediaType"
        case showID = "mediaId"
        case isFavourite = "favorite"
    }

}
