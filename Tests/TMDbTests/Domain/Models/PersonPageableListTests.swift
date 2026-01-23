//
//  PersonPageableListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct PersonPageableListTests {

    @Test("JSON decoding of PersonPageableList", .tags(.decoding))
    func decodeReturnsPersonPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonPageableList.self, fromResource: "person-pageable-list")

        #expect(result.page == list.page)
        #expect(result.results == list.results)
        #expect(result.totalResults == list.totalResults)
        #expect(result.totalPages == list.totalPages)
    }

    private let list = PersonPageableList(
        page: 1,
        results: [
            PersonListItem(
                id: 115_440,
                name: "Sydney Sweeney",
                originalName: "Sydney Sweeney",
                knownForDepartment: "Acting",
                gender: .female,
                profilePath: URL(string: "/qYiaSl0Eb7G3VaxOg8PxExCFwon.jpg"),
                popularity: 155.195,
                knownFor: [
                    .tvSeries(
                        TVSeriesListItem(
                            id: 85552,
                            name: "Euphoria",
                            originalName: "Euphoria",
                            originalLanguage: "en",
                            // swiftlint:disable:next line_length
                            overview: "A group of high school students navigate love and friendships in a world of drugs, sex, trauma, and social media.",
                            genreIDs: [18],
                            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2019-06-16"),
                            originCountries: ["US"],
                            posterPath: URL(string: "/3Q0hd3heuWwDWpwcDkhQOA6TYWI.jpg"),
                            backdropPath: URL(string: "/9KnIzPCv9XpWA0MqmwiKBZvV1Sj.jpg"),
                            popularity: 275.676,
                            voteAverage: 8.324,
                            voteCount: 9506,
                            isAdultOnly: false
                        )
                    ),
                    .movie(
                        MovieListItem(
                            id: 1_072_790,
                            title: "Anyone But You",
                            originalTitle: "Anyone But You",
                            originalLanguage: "en",
                            // swiftlint:disable:next line_length
                            overview: "After an amazing first date, Bea and Ben's fiery attraction turns ice cold — until they find themselves unexpectedly reunited at a destination wedding in Australia. So they do what any two mature adults would do: pretend to be a couple.",
                            genreIDs: [10749, 35],
                            releaseDate: DateFormatter.theMovieDatabase.date(from: "2023-12-21"),
                            posterPath: URL(string: "/yRt7MGBElkLQOYRvLTT1b3B1rcp.jpg"),
                            backdropPath: URL(string: "/j9eOeLlTGoHoM8BNUJVNyWmIvCi.jpg"),
                            popularity: 195.126,
                            voteAverage: 7.056,
                            voteCount: 1611,
                            hasVideo: false,
                            isAdultOnly: false
                        )
                    )
                ],
                isAdultOnly: false
            )
        ],
        totalResults: 1,
        totalPages: 1
    )

}
