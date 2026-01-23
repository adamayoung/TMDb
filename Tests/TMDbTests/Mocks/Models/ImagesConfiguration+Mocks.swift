//
//  ImagesConfiguration+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ImagesConfiguration {

    // swiftlint:disable force_unwrapping
    static func mock(
        baseURL: URL = URL(string: "http://api.domain.com/v1/")!,
        secureBaseURL: URL = URL(string: "https://api.domain.com/v1/")!,
        backdropSizes: [String] = ["w300"],
        logoSizes: [String] = ["w45"],
        posterSizes: [String] = ["w92"],
        profileSizes: [String] = ["w45"],
        stillSizes: [String] = ["w92"]
    ) -> ImagesConfiguration {
        // swiftlint:enable force_unwrapping
        ImagesConfiguration(
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
