//
//  LanguaguesConfigurationRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class LanguaguesConfigurationRequest: DecodableAPIRequest<[Language]> {

    init() {
        let path = "/configuration/languages"

        super.init(path: path)
    }

}
