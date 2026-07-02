//
//  PersonTaggedImagesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonTaggedImagesRequest: DecodableAPIRequest<TaggedImagePageableList> {

    init(id: Person.ID, page: Int? = nil) {
        let path = "/person/\(id)/tagged_images"
        let queryItems = APIRequestQueryItems(page: page)

        super.init(path: path, queryItems: queryItems)
    }

}

private extension APIRequestQueryItems {

    init(page: Int?) {
        self.init()

        self[ifPresent: .page] = page
    }

}
