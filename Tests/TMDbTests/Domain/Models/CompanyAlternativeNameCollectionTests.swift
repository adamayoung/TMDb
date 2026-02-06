//
//  CompanyAlternativeNameCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CompanyAlternativeNameCollectionTests {

    @Test("JSON decoding of CompanyAlternativeNameCollection", .tags(.decoding))
    func decodeReturnsCompanyAlternativeNameCollection() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(
                CompanyAlternativeNameCollection.self,
                fromResource: "company-alternative-names"
            )

        #expect(result.id == 3)
        #expect(result.results.count == 2)
        #expect(result.results[0].name == "Pixar Animation Studios")
        #expect(result.results[0].type == "doing business as")
        #expect(result.results[1].name == "DisneyPixar")
        #expect(result.results[1].type == "")
    }

}
