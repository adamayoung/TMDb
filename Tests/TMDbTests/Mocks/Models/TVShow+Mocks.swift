import Foundation
@testable import TMDb

extension TVShow {

    static func mock(
        id: Int = .randomID,
        name: String? = nil,
        originalName: String? = nil,
        originalLanguage: String? = nil,
        overview: String? = .randomString,
        episodeRunTime: [Int]? = nil,
        numberOfSeasons: Int? = nil,
        numberOfEpisodes: Int? = nil,
        seasons: [TVShowSeason]? = nil,
        genres: [Genre]? = nil,
        firstAirDate: Date? = .random,
        originCountry: [String]? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        homepageURL: URL? = nil,
        inProduction: Bool? = nil,
        languages: [String]? = nil,
        lastAirDate: Date? = nil,
        networks: [Network]? = nil,
        productionCompanies: [ProductionCompany]? = nil,
        status: String? = nil,
        type: String? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) -> Self {
        .init(
            id: id,
            name: name ?? "TV Show \(id)",
            originalName: originalName,
            originalLanguage: originalLanguage,
            overview: overview,
            episodeRunTime: episodeRunTime,
            numberOfSeasons: numberOfSeasons,
            numberOfEpisodes: numberOfEpisodes,
            seasons: seasons,
            genres: genres,
            firstAirDate: firstAirDate,
            originCountry: originCountry,
            posterPath: posterPath,
            backdropPath: backdropPath,
            homepageURL: homepageURL,
            inProduction: inProduction,
            languages: languages,
            lastAirDate: lastAirDate,
            networks: networks,
            productionCompanies: productionCompanies,
            status: status,
            type: type,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }

    static var sheHulk: Self {
        .mock(
            id: 92783,
            name: "She-Hulk: Attorney at Law",
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2022-08-18"),
            posterPath: URL(string: "/hJfI6AGrmr4uSHRccfJuSsapvOb.jpg")!
        )
    }

    static var theSandman: Self {
        .mock(
            id: 90802,
            name: "The Sandman",
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2022-08-05"),
            posterPath: URL(string: "/q54qEgagGOYCq5D1903eBVMNkbo.jpg")!
        )
    }

    static var strangerThings: Self {
        .mock(
            id: 66732,
            name: "Stranger Things",
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2016-07-15"),
            posterPath: URL(string: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg")!
        )
    }

}

extension Array where Element == TVShow {

    static var mocks: [Element] {
        [.sheHulk, .theSandman, .strangerThings]
    }

}
