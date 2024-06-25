//
//  ContentRating+Mocks.swift
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

extension ContentRating {
    static func mock(
        descriptors: [String],
        countryCode: String,
        rating: String
    ) -> Self {
        .init(
            descriptors: descriptors,
            countryCode: countryCode,
            rating: rating
        )
    }

    static var parksAndRecreationGB: Self {
        .mock(descriptors: [], countryCode: "GB", rating: "15")
    }

    static var parksAndRecreationUS: Self {
        .mock(descriptors: [], countryCode: "GB", rating: "TV-14")
    }
}
