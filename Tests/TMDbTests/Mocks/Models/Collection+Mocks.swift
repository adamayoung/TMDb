//
//  Collection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
            // swiftlint:disable:next line_length
            overview: "An epic space-opera theatrical film series, which depicts the adventures of various characters \"a long time ago in a galaxy far, far away….\"",
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
