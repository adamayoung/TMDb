//
//  PageableListResult+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation
import TMDb

public extension PageableListResult where Result == CollectionListItem {

    ///
    /// A sample pageable list of collection list items, for use in tests and previews.
    ///
    static var sample: PageableListResult<CollectionListItem> {
        PageableListResult(
            page: 1,
            results: [
                CollectionListItem(
                    id: 86311,
                    title: "The Avengers Collection",
                    originalTitle: "The Avengers Collection",
                    originalLanguage: "en",
                    overview: """
                    A superhero film series produced by Marvel Studios based on the Marvel Comics \
                    superhero team of the same name, and part of the Marvel Cinematic Universe (MCU). \
                    The series features an ensemble cast from the Marvel Cinematic Universe series \
                    films, as they join forces for the peacekeeping organization S.H.I.E.L.D. led by \
                    Nick Fury.
                    """,
                    posterPath: URL(string: "/yFSIUVTCvgYrpalUktulvk3Gi5Y.jpg"),
                    backdropPath: URL(string: "/2UNUv4NJdC36E5myDHACBJ99EwL.jpg"),
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == ProductionCompany {

    ///
    /// A sample pageable list of production companies, for use in tests and previews.
    ///
    static var sample: PageableListResult<ProductionCompany> {
        PageableListResult(
            page: 1,
            results: [
                ProductionCompany(
                    id: 420,
                    name: "Marvel Studios",
                    originCountry: "US",
                    logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == Keyword {

    ///
    /// A sample pageable list of keywords, for use in tests and previews.
    ///
    static var sample: PageableListResult<Keyword> {
        PageableListResult(
            page: 1,
            results: [
                Keyword(id: 378, name: "prison")
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == MediaListSummary {

    ///
    /// A sample pageable list of media list summaries, for use in tests and previews.
    ///
    static var sample: PageableListResult<MediaListSummary> {
        PageableListResult(
            page: 1,
            results: [
                MediaListSummary(
                    id: 8_175_729,
                    name: "Marvel Cinematic Universe",
                    description: "Every film in the Marvel Cinematic Universe, in release order.",
                    itemCount: 35,
                    favoriteCount: 0,
                    iso6391: "en",
                    iso31661: "US",
                    listType: "movie",
                    posterPath: URL(string: "/yFSIUVTCvgYrpalUktulvk3Gi5Y.jpg")
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == Media {

    ///
    /// A sample pageable list of media items, for use in tests and previews.
    ///
    static var sample: PageableListResult<Media> {
        PageableListResult(
            page: 1,
            results: [
                .movie(
                    MovieListItem(
                        id: 1_084_244,
                        title: "Toy Story 5",
                        originalTitle: "Toy Story 5",
                        originalLanguage: "en",
                        originCountry: ["US"],
                        overview: """
                        When Bonnie receives a Lilypad tablet as a gift and becomes obsessed, Buzz, \
                        Woody, Jessie and the rest of the gang's jobs become exponentially harder when \
                        they have to go head to head with the all-new threat to playtime.
                        """,
                        genreIDs: [16, 10751, 35, 12],
                        releaseDate: nil,
                        posterPath: URL(string: "/a6H2U7pjibMia41TwyFVd1PVQw3.jpg"),
                        backdropPath: URL(string: "/qjTqY5coNiz6sVtPng40IzltsoN.jpg"),
                        popularity: 345.7913,
                        voteAverage: 7.5,
                        voteCount: 227,
                        hasVideo: false,
                        isAdultOnly: false
                    )
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == MovieListItem {

    ///
    /// A sample pageable list of movie list items, for use in tests and previews.
    ///
    static var sample: PageableListResult<MovieListItem> {
        PageableListResult(
            page: 1,
            results: [
                MovieListItem(
                    id: 1_084_244,
                    title: "Toy Story 5",
                    originalTitle: "Toy Story 5",
                    originalLanguage: "en",
                    originCountry: ["US"],
                    overview: """
                    When Bonnie receives a Lilypad tablet as a gift and becomes obsessed, Buzz, Woody, \
                    Jessie and the rest of the gang's jobs become exponentially harder when they have \
                    to go head to head with the all-new threat to playtime.
                    """,
                    genreIDs: [16, 10751, 35, 12],
                    releaseDate: nil,
                    posterPath: URL(string: "/a6H2U7pjibMia41TwyFVd1PVQw3.jpg"),
                    backdropPath: URL(string: "/qjTqY5coNiz6sVtPng40IzltsoN.jpg"),
                    popularity: 345.7913,
                    voteAverage: 7.5,
                    voteCount: 227,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == MediaListItem {

    ///
    /// A sample pageable list of media list items, for use in tests and previews.
    ///
    static var sample: PageableListResult<MediaListItem> {
        PageableListResult(
            page: 1,
            results: [
                MediaListItem(
                    id: 1_084_244,
                    mediaType: .movie,
                    title: "Toy Story 5",
                    originalTitle: "Toy Story 5",
                    originalLanguage: "en",
                    overview: """
                    When Bonnie receives a Lilypad tablet as a gift and becomes obsessed, Buzz, Woody, \
                    Jessie and the rest of the gang's jobs become exponentially harder when they have \
                    to go head to head with the all-new threat to playtime.
                    """,
                    genreIDs: [16, 10751, 35, 12],
                    releaseDate: nil,
                    posterPath: URL(string: "/a6H2U7pjibMia41TwyFVd1PVQw3.jpg"),
                    backdropPath: URL(string: "/qjTqY5coNiz6sVtPng40IzltsoN.jpg"),
                    popularity: 345.7913,
                    voteAverage: 7.5,
                    voteCount: 227,
                    hasVideo: false,
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == PersonListItem {

    ///
    /// A sample pageable list of person list items, for use in tests and previews.
    ///
    static var sample: PageableListResult<PersonListItem> {
        PageableListResult(
            page: 1,
            results: [
                PersonListItem(
                    id: 500,
                    name: "Tom Cruise",
                    originalName: "Tom Cruise",
                    knownForDepartment: "Acting",
                    gender: .male,
                    profilePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    popularity: 12.3,
                    knownFor: nil,
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == Review {

    ///
    /// A sample pageable list of reviews, for use in tests and previews.
    ///
    static var sample: PageableListResult<Review> {
        PageableListResult(
            page: 1,
            results: [
                Review(
                    id: "5b1c13b9c3a36848f2026384",
                    author: "Goddard",
                    content: """
                    Pretty awesome movie.  It shows what one crazy person can convince other crazy \
                    people to do.  Everyone needs something to believe in.  I recommend Jesus Christ, \
                    but they want Tyler Durden.
                    """
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == TVEpisode {

    ///
    /// A sample pageable list of TV episodes, for use in tests and previews.
    ///
    static var sample: PageableListResult<TVEpisode> {
        PageableListResult(
            page: 1,
            results: [
                TVEpisode(
                    id: 63056,
                    name: "Winter Is Coming",
                    episodeNumber: 1,
                    seasonNumber: 1,
                    overview: """
                    Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his \
                    oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys \
                    Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.
                    """
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == TVSeriesListItem {

    ///
    /// A sample pageable list of TV series list items, for use in tests and previews.
    ///
    static var sample: PageableListResult<TVSeriesListItem> {
        PageableListResult(
            page: 1,
            results: [
                TVSeriesListItem(
                    id: 1399,
                    name: "Game of Thrones",
                    originalName: "Game of Thrones",
                    originalLanguage: "en",
                    overview: """
                    Seven noble families fight for control of the mythical land of Westeros. Friction \
                    between the houses leads to full-scale war. All while a very ancient evil awakens \
                    in the farthest north. Amidst the war, a neglected military order of misfits, the \
                    Night's Watch, is all that stands between the realms of men and icy horrors \
                    beyond.
                    """,
                    genreIDs: [10765, 18, 10759],
                    firstAirDate: nil,
                    originCountries: ["US"],
                    posterPath: URL(string: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg"),
                    backdropPath: URL(string: "/2OMB0ynKlyIenMJWI2Dy9IWT4c.jpg"),
                    popularity: 214.3149,
                    voteAverage: 8.463,
                    voteCount: 27072,
                    isAdultOnly: false
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == TaggedImage {

    ///
    /// A sample pageable list of tagged images, for use in tests and previews.
    ///
    static var sample: PageableListResult<TaggedImage> {
        let filePath = URL(string: "/a6H2U7pjibMia41TwyFVd1PVQw3.jpg")
            ?? URL(fileURLWithPath: "/")
        let movie = MovieListItem(
            id: 1_084_244,
            title: "Toy Story 5",
            originalTitle: "Toy Story 5",
            originalLanguage: "en",
            originCountry: ["US"],
            overview: """
            When Bonnie receives a Lilypad tablet as a gift and becomes obsessed, Buzz, Woody, Jessie \
            and the rest of the gang's jobs become exponentially harder when they have to go head to \
            head with the all-new threat to playtime.
            """,
            genreIDs: [16, 10751, 35, 12]
        )

        return PageableListResult(
            page: 1,
            results: [
                TaggedImage(
                    id: "59164af592514156f50269b6",
                    aspectRatio: 0.667,
                    filePath: filePath,
                    height: 3000,
                    width: 2000,
                    languageCode: "en",
                    countryCode: "US",
                    voteAverage: 6.5,
                    voteCount: 19,
                    imageType: "poster",
                    media: .movie(movie)
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
    }

}

public extension PageableListResult where Result == TrendingItem {

    ///
    /// A sample pageable list of trending items, for use in tests and previews.
    ///
    static var sample: PageableListResult<TrendingItem> {
        let movie = MovieListItem(
            id: 1_084_244,
            title: "Toy Story 5",
            originalTitle: "Toy Story 5",
            originalLanguage: "en",
            originCountry: ["US"],
            overview: """
            When Bonnie receives a Lilypad tablet as a gift and becomes obsessed, Buzz, Woody, Jessie \
            and the rest of the gang's jobs become exponentially harder when they have to go head to \
            head with the all-new threat to playtime.
            """,
            genreIDs: [16, 10751, 35, 12],
            releaseDate: nil,
            posterPath: URL(string: "/a6H2U7pjibMia41TwyFVd1PVQw3.jpg"),
            backdropPath: URL(string: "/qjTqY5coNiz6sVtPng40IzltsoN.jpg"),
            popularity: 345.7913,
            voteAverage: 7.5,
            voteCount: 227,
            hasVideo: false,
            isAdultOnly: false
        )

        return PageableListResult(
            page: 1,
            results: [.movie(movie)],
            totalResults: 1,
            totalPages: 1
        )
    }

}
