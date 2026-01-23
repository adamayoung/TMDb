//
//  WatchProviderResultTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct WatchProviderResultTests {

    @Test("JSON decoding of WatchProviderRegions", .tags(.decoding))
    func decodeReturnsWatchProviderResult() throws {
        let watchProviderResult = WatchProviderResult(
            results: [
                .init(
                    id: 8,
                    name: "Netflix",
                    logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                ),
                .init(
                    id: 9,
                    name: "Amazon Prime Video",
                    logoPath: URL(string: "/emthp39XA2YScoYL1p0sdbAH2WA.jpg")
                )
            ]
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            WatchProviderResult.self,
            fromResource: "watch-provider-result"
        )

        #expect(result == watchProviderResult)
    }

}
