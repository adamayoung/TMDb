//
//  NetworkRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class NetworkRequest: DecodableAPIRequest<Network> {

    init(id: Network.ID) {
        let path = "/network/\(id)"

        super.init(path: path)
    }

}
