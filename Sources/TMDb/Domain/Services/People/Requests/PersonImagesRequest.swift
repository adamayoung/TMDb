//
//  PersonImagesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonImagesRequest: DecodableAPIRequest<PersonImageCollection> {

    init(id: Person.ID) {
        let path = "/person/\(id)/images"

        super.init(path: path)
    }

}
