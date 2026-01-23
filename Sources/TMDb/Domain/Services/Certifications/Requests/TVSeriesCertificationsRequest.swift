//
//  TVSeriesCertificationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class TVSeriesCertificationsRequest: DecodableAPIRequest<Certifications> {

    init() {
        let path = "/certification/tv/list"

        super.init(path: path)
    }

}
