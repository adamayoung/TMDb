//
//  KeywordCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct KeywordCollectionTests {

    /// `KeywordCollection` maps the wire's `results` onto its `keywords`
    /// property. The movie side of the API sends `keywords` and decodes into a
    /// different type, so this remap had no fixture covering it.
    @Test("JSON decoding of KeywordCollection remaps results onto keywords")
    func decodeReturnsKeywordCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            KeywordCollection.self,
            fromResource: "tv-series-keywords"
        )

        #expect(result.id == 1396)
        #expect(result.keywords.count == 3)

        let newMexico = try #require(result.keywords.first { $0.id == 1508 })
        #expect(newMexico.name == "new mexico")

        let crystalMeth = try #require(result.keywords.first { $0.id == 239_108 })
        #expect(crystalMeth.name == "crystal meth")
    }

}
