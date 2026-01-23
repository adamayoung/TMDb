//
//  APIConfigurationRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class APIConfigurationRequest: DecodableAPIRequest<APIConfiguration> {

    init() {
        let path = "/configuration"

        super.init(path: path)
    }

}
