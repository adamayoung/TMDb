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

    /// A `known_for` entry this library cannot model must not take the whole
    /// person with it. Before this, the sentinel escaped `PersonListItem` and the
    /// enclosing page dropped the person entirely.
    @Test("an unmodelled known_for entry is skipped, keeping the person", .tags(.decoding))
    func decodeSkipsUnmodelledKnownForEntryKeepingThePerson() throws {
        let json = """
        {
          "id": 287,
          "name": "Brad Pitt",
          "original_name": "William Bradley Pitt",
          "gender": 2,
          "known_for": [
            {
              "id": 1,
              "title": "A Movie",
              "original_title": "A Movie",
              "original_language": "en",
              "overview": "An overview.",
              "media_type": "movie"
            },
            {"id": 2, "name": "A Future Thing", "media_type": "podcast"}
          ]
        }
        """

        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonListItem.self, from: Data(json.utf8)
        )

        #expect(result.id == 287)
        #expect(result.knownFor?.count == 1)
        #expect(result.droppedItemCount == 1)
    }

    /// `nil` and `[]` are different on a public optional, and the synthesized
    /// encoder writes the key for one and omits it for the other.
    @Test("an absent known_for decodes as nil, not an empty array", .tags(.decoding))
    func decodeAbsentKnownForAsNil() throws {
        let json = """
        {"id": 287, "name": "Brad Pitt", "original_name": "William Bradley Pitt", "gender": 2}
        """

        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonListItem.self, from: Data(json.utf8)
        )

        #expect(result.knownFor == nil)
        #expect(result.droppedItemCount == 0)
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
