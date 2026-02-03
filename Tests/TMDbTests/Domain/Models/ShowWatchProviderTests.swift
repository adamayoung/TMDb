//
//  ShowWatchProviderTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct ShowWatchProviderTests {

    @Test("JSON decoding of ShowWatchProvider")
    func decodeReturnsShowWatchProvider() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowWatchProvider.self,
            fromResource: "show-watch-provider"
        )

        #expect(result.link == showWatchProvider.link)
        #expect(result.flatRate == showWatchProvider.flatRate)
        #expect(result.buy == showWatchProvider.buy)
        #expect(result.rent == showWatchProvider.rent)
        #expect(result.free == showWatchProvider.free)
    }

}

extension ShowWatchProviderTests {

    private var showWatchProvider: ShowWatchProvider {
        ShowWatchProvider(
            link: "https://www.themoviedb.org/movie/550-fight-club/watch",
            free: [
                WatchProvider(
                    id: 300,
                    name: "Pluto TV",
                    logoPath: URL(string: "/aS2zvJWn9mwiCOeaaCkIh4wleZS.jpg")
                )
            ],
            flatRate: [
                WatchProvider(
                    id: 8,
                    name: "Netflix",
                    logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                )
            ],
            buy: [
                WatchProvider(
                    id: 2,
                    name: "Apple TV",
                    logoPath: URL(string: "/peURlLlr8jggOwK53fJ5wdQl05y.jpg")
                )
            ],
            rent: [
                WatchProvider(
                    id: 2,
                    name: "Apple TV",
                    logoPath: URL(string: "/peURlLlr8jggOwK53fJ5wdQl05y.jpg")
                )
            ]
        )
    }

}
