//
//  PersonExternalLinksRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class PersonExternalLinksRequest: DecodableAPIRequest<PersonExternalLinksCollection> {

    init(id: Person.ID) {
        let path = "/person/\(id)/external_ids"

        super.init(path: path)
    }

}
