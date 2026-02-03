//
//  CollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CollectionTests {

    @Test("JSON decoding of Collection", .tags(.decoding))
    func decodeReturnsCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Collection.self,
            fromResource: "collection"
        )

        #expect(result.id == 10)
        #expect(result.name == "Star Wars Collection")
        #expect(result.originalName == "Star Wars Collection")
        #expect(result.originalLanguage == "en")
        // swiftlint:disable:next line_length
        let expectedOverview = "An epic space-opera theatrical film series, which depicts the adventures of various characters \"a long time ago in a galaxy far, far away….\""
        #expect(result.overview == expectedOverview)
        #expect(result.posterPath == URL(string: "/22dj38IckjzEEUZwN1tPU5VJ1qq.jpg"))
        #expect(result.backdropPath == URL(string: "/qVPChlozQ1BP3svfHjiAdNneMGA.jpg"))
        #expect(result.parts.count == 2)
        #expect(result.parts[0].id == 11)
        #expect(result.parts[0].title == "Star Wars")
        #expect(result.parts[1].id == 1891)
        #expect(result.parts[1].title == "The Empire Strikes Back")
    }

}
