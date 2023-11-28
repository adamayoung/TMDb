//
//  Review+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

extension Review {

    static func mock(
        id: String = .randomID,
        author: String? = nil,
        content: String = .randomString
    ) -> Self {
        .init(
            id: id,
            author: author ?? "Author \(String.randomID)",
            content: content
        )
    }

}

extension [Review] {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
