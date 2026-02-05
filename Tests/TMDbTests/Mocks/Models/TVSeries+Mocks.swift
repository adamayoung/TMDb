//
//  TVSeries+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension TVSeries {

    static func mock(
        id: Int = 1,
        name: String? = nil,
        originalName: String? = nil,
        originalLanguage: String? = nil,
        overview: String? = "TV Series Overview",
        episodeRunTime: [Int]? = nil,
        numberOfSeasons: Int? = nil,
        numberOfEpisodes: Int? = nil,
        seasons: [TVSeason]? = nil,
        createdBy: [Creator]? = nil,
        genres: [Genre]? = nil,
        firstAirDate: Date? = Date(iso8601: "2013-11-15T10:20:00Z"),
        originCountry: [String]? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        homepageURL: URL? = nil,
        inProduction: Bool? = nil,
        languages: [String]? = nil,
        lastAirDate: Date? = nil,
        networks: [Network]? = nil,
        productionCompanies: [ProductionCompany]? = nil,
        productionCountries: [ProductionCountry]? = nil,
        spokenLanguages: [SpokenLanguage]? = nil,
        status: String? = nil,
        type: String? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) -> TVSeries {
        TVSeries(
            id: id,
            name: name ?? "TV Series \(id)",
            originalName: originalName,
            originalLanguage: originalLanguage,
            overview: overview,
            episodeRunTime: episodeRunTime,
            numberOfSeasons: numberOfSeasons,
            numberOfEpisodes: numberOfEpisodes,
            seasons: seasons,
            createdBy: createdBy,
            genres: genres,
            firstAirDate: firstAirDate,
            originCountry: originCountry,
            posterPath: posterPath,
            backdropPath: backdropPath,
            homepageURL: homepageURL,
            isInProduction: inProduction,
            languages: languages,
            lastAirDate: lastAirDate,
            networks: networks,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: spokenLanguages,
            status: status,
            type: type,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }

    static var sheHulk: TVSeries {
        TVSeries.mock(
            id: 92783,
            name: "She-Hulk: Attorney at Law",
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2022-08-18"),
            posterPath: URL(string: "/hJfI6AGrmr4uSHRccfJuSsapvOb.jpg")
        )
    }

    static var theSandman: TVSeries {
        TVSeries.mock(
            id: 90802,
            name: "The Sandman",
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2022-08-05"),
            posterPath: URL(string: "/q54qEgagGOYCq5D1903eBVMNkbo.jpg")
        )
    }

    static var strangerThings: TVSeries {
        TVSeries.mock(
            id: 66732,
            name: "Stranger Things",
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2016-07-15"),
            posterPath: URL(string: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg")
        )
    }

}

extension [TVSeries] {

    static var mocks: [TVSeries] {
        [.sheHulk, .theSandman, .strangerThings]
    }

}
