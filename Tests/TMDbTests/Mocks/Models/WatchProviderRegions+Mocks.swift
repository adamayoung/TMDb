//
//  WatchProviderRegions+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
@testable import TMDb

extension WatchProviderRegions {

    static var mock: Self {
        .init(
            results: [
                .init(countryCode: "AR", name: "Argentina", englishName: "Argentina"),
                .init(countryCode: "AT", name: "Austria", englishName: "Austria"),
                .init(countryCode: "US", name: "United States", englishName: "United States of America")
            ]
        )
    }

}
