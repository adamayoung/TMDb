//
//  MovieCertificationsRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

final class MovieCertificationsRequest: DecodableAPIRequest<Certifications> {

    init() {
        let path = "/certification/movie/list"

        super.init(path: path)
    }

}
