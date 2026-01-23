//
//  Company+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Company {

    // swift-format-ignore: NeverForceUnwrap
    // swiftlint:disable:next function_default_parameter_at_end
    static func mock(
        id: Int = 1,
        name: String = "Lucasfilm Ltd.",
        description: String = "Some description",
        headquarters: String = "San Francisco, California",
        homepageURL: URL? = URL(string: "https://www.lucasfilm.com"),
        // swiftlint:disable:next force_unwrapping
        logoPath: URL = URL(string: "/o86DbpburjxrqAzEDhXZcyE8pDb.png")!,
        originCountry: String = "US",
        parentCompany: Company.Parent? = nil
    ) -> Company {
        Company(
            id: id,
            name: name,
            description: description,
            headquarters: headquarters,
            homepageURL: homepageURL,
            logoPath: logoPath,
            originCountry: originCountry,
            parentCompany: parentCompany
        )
    }

    // swift-format-ignore: NeverForceUnwrap
    static var lucasfilm: Company {
        // swiftlint:disable:next force_unwrapping
        let logoPath = URL(string: "/o86DbpburjxrqAzEDhXZcyE8pDb.png")!
        return Company.mock(
            id: 1,
            name: "Lucasfilm Ltd.",
            description: "Some description",
            headquarters: "San Francisco, California",
            homepageURL: URL(string: "https://www.lucasfilm.com"),
            logoPath: logoPath,
            originCountry: "US"
        )
    }

}
