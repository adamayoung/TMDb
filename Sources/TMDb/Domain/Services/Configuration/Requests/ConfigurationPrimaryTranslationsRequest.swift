//
//  ConfigurationPrimaryTranslationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class ConfigurationPrimaryTranslationsRequest: DecodableAPIRequest<[String]> {

    init() {
        let path = "/configuration/primary_translations"

        super.init(path: path)
    }

}
