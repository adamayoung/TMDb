//
//  MovieCastCreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct MovieCastCreditTests {

    @Test("JSON decoding of MovieCastCredit", .tags(.decoding))
    func decodeReturnsMovieCastCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieCastCredit.self, fromResource: "movie-cast-credit"
        )

        #expect(result == credit)
    }

}

extension MovieCastCreditTests {

    private var credit: MovieCastCredit {
        .init(
            id: 109_091,
            title: "The Counselor",
            originalTitle: "The Counselor",
            originalLanguage: "en",
            // swiftlint:disable:next line_length
            overview: "A rich and successful lawyer named Counselor is about to get married to his fiancée but soon meets up with the middle-man known as Westray who tells him his drug trafficking plan has taken a horrible twist and now he must protect himself and his soon bride-to-be lover as the truth of the drug business uncovers and targets become chosen.",
            genreIDs: [80, 18, 53],
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2013-10-25"),
            posterPath: URL(string: "/uxp6rHVBzUqZCyTaUI8xzUP5sOf.jpg"),
            backdropPath: URL(string: "/62xHmGnxMi0wV40BS3iKnDru0nO.jpg"),
            popularity: 3.597124,
            voteAverage: 5,
            voteCount: 661,
            hasVideo: false,
            isAdultOnly: false,
            character: "Westray",
            creditID: "52fe4aaac3a36847f81db47d",
            order: 0
        )
    }

}
