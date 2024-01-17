//
//  Company+Mocks.swift
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

extension Company {

    static func mock(
        id: Int = .randomID,
        name: String = .randomString,
        description: String = .randomString,
        headquarters: String = .randomString,
        homepage: URL = .randomWebSite,
        logoPath: URL = .randomImagePath,
        originCountry: String = "US",
        parentCompany: Company.Parent? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            description: description,
            headquarters: headquarters,
            homepage: homepage,
            logoPath: logoPath,
            originCountry: originCountry,
            parentCompany: parentCompany
        )
    }

    static var lucasfilm: Self {
        .mock(
            id: 1,
            name: "Lucasfilm Ltd.",
            description: "Some description",
            headquarters: "San Francisco, California",
            homepage: URL(string: "https://www.lucasfilm.com")!,
            logoPath: URL(string: "/o86DbpburjxrqAzEDhXZcyE8pDb.png")!,
            originCountry: "US"
        )
    }

}
