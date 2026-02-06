//
//  CompanyImageCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CompanyImageCollectionTests {

    @Test("JSON decoding of CompanyImageCollection", .tags(.decoding))
    func decodeReturnsCompanyImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(
                CompanyImageCollection.self,
                fromResource: "company-images"
            )

        #expect(result.id == 3)
        #expect(result.logos.count == 2)
        #expect(result.logos[0].width == 887)
        #expect(result.logos[0].height == 186)
        #expect(result.logos[1].width == 667)
        #expect(result.logos[1].height == 108)
    }

}
