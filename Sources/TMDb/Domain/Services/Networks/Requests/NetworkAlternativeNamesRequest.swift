//
//  NetworkAlternativeNamesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class NetworkAlternativeNamesRequest: DecodableAPIRequest<NetworkAlternativeNamesResponse> {

    init(id: Network.ID) {
        let path = "/network/\(id)/alternative_names"

        super.init(path: path)
    }

}

struct NetworkAlternativeNamesResponse: Decodable {

    let id: Int
    let results: [NetworkAlternativeName]

}
