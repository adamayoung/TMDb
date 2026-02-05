//
//  LatestPersonRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class LatestPersonRequest: DecodableAPIRequest<Person> {

    init() {
        let path = "/person/latest"

        super.init(path: path)
    }

}
