//
//  Collection+Mocks.swift
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
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

@testable import TMDb

extension Collection {

    static var mock: Self {
        Collection(
            id: 10,
            name: "Star Wars Collection",
            originalName: "Star Wars Collection",
            originalLanguage: "en",
            overview:
                "An epic space-opera theatrical film series, which depicts the adventures of various characters \"a long time ago in a galaxy far, far away….\"",
            posterPath: URL(string: "/22dj38IckjzEEUZwN1tPU5VJ1qq.jpg"),
            backdropPath: URL(string: "/qVPChlozQ1BP3svfHjiAdNneMGA.jpg"),
            parts: [.mock()]
        )
    }

    static var mockWithNilPaths: Self {
        Collection(
            id: 10,
            name: "Test Collection",
            originalName: "Test Collection",
            originalLanguage: "en",
            overview: "Test overview",
            posterPath: nil,
            backdropPath: nil,
            parts: []
        )
    }

}
