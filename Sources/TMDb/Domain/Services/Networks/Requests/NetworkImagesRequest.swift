//
//  NetworkImagesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class NetworkImagesRequest: DecodableAPIRequest<NetworkLogosResponse> {

    init(id: Network.ID) {
        let path = "/network/\(id)/images"

        super.init(path: path)
    }

}

struct NetworkLogosResponse: Decodable {

    let id: Int
    let logos: [NetworkLogo]

}
