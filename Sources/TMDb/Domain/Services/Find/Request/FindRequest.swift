//
//  MovieSearchRequest.swift
//  TMDb
//
//  Created by MLabs on 23/06/2025.
//

import Foundation

final class FindRequest: DecodableAPIRequest<FindResponse> {

    init(id: String,
         externalSource: FindServiceType,
         language: String? = nil
    ) {
        let path = "/find/\(id)"
        let queryItems = APIRequestQueryItems(source: externalSource.rawValue,
                                              language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

extension APIRequestQueryItems {

    fileprivate init(source: String, language: String?) {
        self.init()

        self[.externalSource] = source
        
        if let language {
            self[.language] = language
        }
    }

}
