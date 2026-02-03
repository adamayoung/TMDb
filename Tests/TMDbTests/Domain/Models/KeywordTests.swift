//
//  KeywordTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct KeywordTests {

    @Test("JSON decoding of Keyword", .tags(.decoding))
    func decodeKeyword() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Keyword.self,
            fromResource: "keyword"
        )

        #expect(result.id == keyword.id)
        #expect(result.name == keyword.name)
    }

    private let keyword = Keyword(
        id: 378,
        name: "prison"
    )

}
