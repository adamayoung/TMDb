//
//  CreditMovieTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .credit))
struct CreditMovieTests {

    @Test("JSON decoding of CreditMovie", .tags(.decoding))
    func decodeCreditMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Credit.self,
            fromResource: "credit-movie"
        )

        guard case .movie(let movie) = result.media else {
            Issue.record("Expected movie media type")
            return
        }

        #expect(movie == fightClub)
    }

    @Test(
        "JSON decoding of CreditMovie with an empty release date returns nil release date",
        .tags(.decoding)
    )
    func decodeCreditMovieWithEmptyReleaseDateReturnsNilReleaseDate() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Credit.self,
            fromResource: "credit-movie-blank-release-date"
        )

        guard case .movie(let movie) = result.media else {
            Issue.record("Expected movie media type")
            return
        }

        #expect(movie.id == 1_047_807)
        #expect(movie.title == "Heat 2")
        #expect(movie.releaseDate == nil)
        #expect(movie.character == nil)
        #expect(movie.backdropPath == nil)
    }

    @Test(
        "JSON decoding of CreditMovie without optional properties returns nil properties",
        .tags(.decoding)
    )
    func decodeCreditMovieWithoutOptionalPropertiesReturnsNilProperties() throws {
        let data = Data(#"{"media_type": "movie", "id": 550}"#.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(
            CreditMedia.self,
            from: data
        )

        guard case .movie(let movie) = result else {
            Issue.record("Expected movie media type")
            return
        }

        #expect(movie.id == 550)
        #expect(movie.title == nil)
        #expect(movie.originalTitle == nil)
        #expect(movie.overview == nil)
        #expect(movie.posterPath == nil)
        #expect(movie.backdropPath == nil)
        #expect(movie.popularity == nil)
        #expect(movie.releaseDate == nil)
        #expect(movie.voteAverage == nil)
        #expect(movie.voteCount == nil)
        #expect(movie.character == nil)
    }

}

extension CreditMovieTests {

    private var fightClub: CreditMovie {
        .init(
            id: 550,
            title: "Fight Club",
            originalTitle: "Fight Club",
            // swiftlint:disable:next line_length
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
            posterPath: URL(string: "/jSziioSwPVrOy9Yow3XhWIBDjq1.jpg"),
            backdropPath: URL(string: "/c6OLXfKAk5BKeR6broC8pYiCquX.jpg"),
            popularity: 44.4391,
            releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-15"),
            voteAverage: 8.437,
            voteCount: 32596,
            character: "Narrator"
        )
    }

}
