//
//  KeywordRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class KeywordRequest: DecodableAPIRequest<Keyword> {

    init(id: Keyword.ID) {
        let path = "/keyword/\(id)"

        super.init(path: path)
    }

}
