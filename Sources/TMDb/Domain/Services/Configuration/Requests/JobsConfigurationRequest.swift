//
//  JobsConfigurationRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class JobsConfigurationRequest: DecodableAPIRequest<[Department]> {

    init() {
        let path = "/configuration/jobs"

        super.init(path: path)
    }

}
