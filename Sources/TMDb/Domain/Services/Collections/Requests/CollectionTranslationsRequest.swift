//
//  CollectionTranslationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class CollectionTranslationsRequest: DecodableAPIRequest<CollectionTranslationsResult> {

    init(id: Collection.ID) {
        let path = "/collection/\(id)/translations"

        super.init(path: path)
    }

}

struct CollectionTranslationsResult: Decodable {

    let id: Int
    let translations: [CollectionTranslation]

}
