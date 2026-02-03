//
//  WatchProviderTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct WatchProviderTests {

    @Test("JSON decoding of WatchProvider", .tags(.decoding))
    func decodeReturnsWatchProvider() throws {
        let watchProvider = WatchProvider(
            id: 8,
            name: "Netflix",
            logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            WatchProvider.self, fromResource: "watch-provider"
        )

        #expect(result == watchProvider)
    }

}
