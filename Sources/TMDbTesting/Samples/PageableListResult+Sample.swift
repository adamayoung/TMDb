//
//  PageableListResult+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

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
                    id: 10,
                    title: "The Avengers Collection",
                    originalTitle: "The Avengers Collection",
                    originalLanguage: "en",
                    overview: "A collection of films featuring Earth's Mightiest Heroes.",
                    posterPath: URL(string: "/8sYdZSdgquS1iO4XzsGy9dN3DJ3.jpg"),
                    backdropPath: nil,
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
                    id: 1,
                    name: "My Watchlist",
                    description: "A list of films to watch.",
                    itemCount: 10,
                    favoriteCount: 5,
                    iso6391: "en",
                    iso31661: "US",
                    listType: "movie",
                    posterPath: URL(string: "/poster.jpg")
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
                        id: 1,
                        title: "Movie",
                        originalTitle: "Movie",
                        originalLanguage: "en",
                        originCountry: ["US"],
                        overview: "Movie overview.",
                        genreIDs: [28],
                        releaseDate: nil,
                        posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                        backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                        popularity: 5.6,
                        voteAverage: 7.3,
                        voteCount: 321,
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
                    id: 1,
                    title: "Movie",
                    originalTitle: "Movie",
                    originalLanguage: "en",
                    originCountry: ["US"],
                    overview: "Movie overview.",
                    genreIDs: [28],
                    releaseDate: nil,
                    posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    popularity: 5.6,
                    voteAverage: 7.3,
                    voteCount: 321,
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
                    id: 1,
                    mediaType: .movie,
                    title: "Movie",
                    originalTitle: "Movie",
                    originalLanguage: "en",
                    overview: "Movie overview.",
                    genreIDs: [28],
                    releaseDate: nil,
                    posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    popularity: 5.6,
                    voteAverage: 7.3,
                    voteCount: 321,
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
                    id: "1",
                    author: "Author Name",
                    content: "Some review content."
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
                    id: 1,
                    name: "TV Episode Name",
                    episodeNumber: 3,
                    seasonNumber: 2,
                    overview: "Overview for TV episode."
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
                    id: 1,
                    name: "TV Series",
                    originalName: "TV Series",
                    originalLanguage: "en",
                    overview: "TV series overview.",
                    genreIDs: [18],
                    firstAirDate: nil,
                    originCountries: ["GB"],
                    posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    popularity: 5,
                    voteAverage: 5,
                    voteCount: 100,
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
        let filePath = URL(string: "/iOpi3ut5DhQIbrVVjlnmfy2U7dI.jpg")
            ?? URL(fileURLWithPath: "/")
        let movie = MovieListItem(
            id: 1,
            title: "Movie",
            originalTitle: "Movie",
            originalLanguage: "en",
            originCountry: ["US"],
            overview: "Movie overview.",
            genreIDs: [28]
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
            id: 1,
            title: "Movie",
            originalTitle: "Movie",
            originalLanguage: "en",
            originCountry: ["US"],
            overview: "Movie overview.",
            genreIDs: [28],
            releaseDate: nil,
            posterPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
            backdropPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
            popularity: 5.6,
            voteAverage: 7.3,
            voteCount: 321,
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
