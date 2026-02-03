//
//  PersonListItemTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct PersonListItemTests {

    @Test("JSON decoding of PersonListItem")
    func decodeReturnsPersonListItem() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonListItem.self,
            fromResource: "person-list-item"
        )

        #expect(result.id == personListItem.id)
        #expect(result.name == personListItem.name)
        #expect(result.originalName == personListItem.originalName)
        #expect(result.knownForDepartment == personListItem.knownForDepartment)
        #expect(result.gender == personListItem.gender)
        #expect(result.profilePath == personListItem.profilePath)
        #expect(result.popularity == personListItem.popularity)
        #expect(result.isAdultOnly == personListItem.isAdultOnly)
        #expect(result.knownFor?.count == personListItem.knownFor?.count)
    }

}

extension PersonListItemTests {

    private var personListItem: PersonListItem {
        PersonListItem(
            id: 287,
            name: "Brad Pitt",
            originalName: "William Bradley Pitt",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: URL(string: "/kU3B75TyRiCgE270EyZnHjfivoq.jpg"),
            popularity: 65.732,
            knownFor: [
                .movie(
                    MovieListItem(
                        id: 550,
                        title: "Fight Club",
                        originalTitle: "Fight Club",
                        originalLanguage: "en",
                        overview:
                        // swiftlint:disable:next line_length
                        "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
                        genreIDs: [27],
                        releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-12"),
                        posterPath: URL(string: "/uGyiewQnDHPuiHN9V4k2t9QBPnh.jpg"),
                        backdropPath: URL(string: "/tkHQ7tnYYUEnqlrKuhufIsSVToU.jpg"),
                        popularity: 1080.713,
                        voteAverage: 7.8,
                        voteCount: 3439,
                        hasVideo: false,
                        isAdultOnly: false
                    )
                )
            ],
            isAdultOnly: false
        )
    }

}
