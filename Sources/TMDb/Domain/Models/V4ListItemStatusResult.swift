//
//  V4ListItemStatusResult.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The response from checking whether an item is in a v4 list.
///
/// Internal: TMDb signals absence with a 404 rather than a flag in this body,
/// so the service maps the whole thing to a `Bool` and this type never reaches
/// a caller.
///
struct V4ListItemStatusResult: Decodable {

    let success: Bool
    let id: Int
    let mediaID: Int
    let mediaType: ShowType

}

extension V4ListItemStatusResult {

    private enum CodingKeys: String, CodingKey {
        case success
        case id
        case mediaID = "mediaId"
        case mediaType
    }

}
