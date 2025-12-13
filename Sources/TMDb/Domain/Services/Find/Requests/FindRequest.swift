//
//  FindRequest.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

final class FindRequest: DecodableAPIRequest<FindResults> {

    init(externalID: String, externalSource: ExternalSource, language: String? = nil) {
        let path = "/find/\(externalID)"
        let queryItems = APIRequestQueryItems(externalSource: externalSource, language: language)

        super.init(path: path, queryItems: queryItems)
    }

}

extension APIRequestQueryItems {

    fileprivate init(externalSource: ExternalSource, language: String?) {
        self.init()

        self[.externalSource] = externalSource.rawValue

        if let language {
            self[.language] = language
        }
    }

}

private extension APIRequestQueryItems.Key {

    static let externalSource = Self(rawValue: "external_source")

}
