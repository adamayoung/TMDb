//
//  ConfigurationTimezonesRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ConfigurationTimezonesRequest: DecodableAPIRequest<[Timezone]> {

    init() {
        let path = "/configuration/timezones"

        super.init(path: path)
    }

}
