//
//  MovieGenreTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(.tags(.languageModelTools))
    struct MovieGenreTests {

        @available(macOS 26, *)
        @Test(
            "each genre maps to its stable TMDb identifier",
            arguments: [
                (MovieGenre.action, 28),
                (.adventure, 12),
                (.animation, 16),
                (.comedy, 35),
                (.crime, 80),
                (.documentary, 99),
                (.drama, 18),
                (.family, 10751),
                (.fantasy, 14),
                (.history, 36),
                (.horror, 27),
                (.music, 10402),
                (.mystery, 9648),
                (.romance, 10749),
                (.scienceFiction, 878),
                (.thriller, 53),
                (.war, 10752),
                (.western, 37)
            ]
        )
        func genreIDMapping(genre: MovieGenre, expectedID: Genre.ID) {
            #expect(genre.genreID == expectedID)
        }

        @available(macOS 26, *)
        @Test("trending window maps to the domain filter type")
        func trendingWindowMapping() {
            #expect(TrendingWindow.day.filterType == .day)
            #expect(TrendingWindow.week.filterType == .week)
        }

    }
#endif
