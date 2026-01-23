//
//  MovieCrewCreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct MovieCrewCreditTests {

    @Test("JSON decoding of MovieCrewCredit", .tags(.decoding))
    func decodeReturnsMovieCrewCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieCrewCredit.self, fromResource: "movie-crew-credit"
        )

        #expect(result == credit)
    }

}

extension MovieCrewCreditTests {

    private var credit: MovieCrewCredit {
        .init(
            id: 174_349,
            title: "Big Men",
            originalTitle: "Big Men",
            originalLanguage: "en",
            overview:
            // swiftlint:disable:next line_length
            "For her latest industrial exposé, Rachel Boynton (Our Brand Is Crisis) gained unprecedented access to Africa's oil companies. The result is a gripping account of the costly personal tolls levied when American corporate interests pursue oil in places like Ghana and the Niger River Delta. Executive produced by Steven Shainberg and Brad Pitt, Big Men investigates the caustic blend of ambition, corruption and greed that threatens to exacerbate Africa's resource curse.",
            genreIDs: [99],
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2014-03-14"),
            posterPath: URL(string: "/q5uKDMl1PXIeMoD10CTbXST7XoN.jpg"),
            backdropPath: URL(string: "/ieWzXfEx3AU9QANrGkbqeXgLeNH.jpg"),
            popularity: 1.214663,
            voteAverage: 6.4,
            voteCount: 7,
            hasVideo: false,
            isAdultOnly: false,
            job: "Executive Producer",
            department: "Production",
            creditID: "52fe4d49c3a36847f8258cf3"
        )
    }

}
