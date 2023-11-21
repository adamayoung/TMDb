//
//  ImagesConfiguration+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension ImagesConfiguration {

    static func mock(
        baseURL: URL = .randomBaseURL(secure: false),
        secureBaseURL: URL = .randomBaseURL(),
        backdropSizes: [String] = ["w300"],
        logoSizes: [String] = ["w45"],
        posterSizes: [String] = ["w92"],
        profileSizes: [String] = ["w45"],
        stillSizes: [String] = ["w92"]
    ) -> Self {
        .init(
            baseURL: baseURL,
            secureBaseURL: secureBaseURL,
            backdropSizes: backdropSizes,
            logoSizes: logoSizes,
            posterSizes: posterSizes,
            profileSizes: profileSizes,
            stillSizes: stillSizes
        )
    }

}
