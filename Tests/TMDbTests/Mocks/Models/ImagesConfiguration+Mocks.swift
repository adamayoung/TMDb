//
//  ImagesConfiguration+Mocks.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import TMDb

extension ImagesConfiguration {

    static func mock(
        baseURL: URL = URL(string: "http://api.domain.com/v1/")!,
        secureBaseURL: URL = URL(string: "https://api.domain.com/v1/")!,
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
