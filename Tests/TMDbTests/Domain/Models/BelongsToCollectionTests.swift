//
//  BelongsToCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct BelongsToCollectionTests {

    @Test("JSON decoding of BelongsToCollection", .tags(.decoding))
    func decodeReturnsBelongsToCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            BelongsToCollection.self, fromResource: "belongs-to-collection"
        )

        #expect(result.id == 1241)
        #expect(result.name == "Harry Potter Collection")
        #expect(result.posterPath == URL(string: "/eVPs2Y0LyvTLZn6AP5Z6O2rtiGB.jpg"))
        #expect(result.backdropPath == URL(string: "/kmEsQL2vOTA0jnM28fXS45Ky8kX.jpg"))
    }

}
