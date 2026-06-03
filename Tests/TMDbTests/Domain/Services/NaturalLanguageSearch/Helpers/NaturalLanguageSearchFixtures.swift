//
//  NaturalLanguageSearchFixtures.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

enum NLSFixture {

    static func date(year: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        return calendar.date(from: DateComponents(year: year, month: 6, day: 1)) ?? Date()
    }

    static func movie(id: Int, title: String = "Movie", year: Int? = nil) -> MovieListItem {
        MovieListItem(
            id: id, title: title, originalTitle: title, originalLanguage: "en",
            overview: "", genreIDs: [], releaseDate: year.map { date(year: $0) }
        )
    }

    static func tvSeries(id: Int, name: String = "Series", year: Int? = nil) -> TVSeriesListItem {
        TVSeriesListItem(
            id: id, name: name, originalName: name, originalLanguage: "en",
            overview: "", genreIDs: [], firstAirDate: year.map { date(year: $0) },
            originCountries: []
        )
    }

    static func person(id: Int, name: String = "Person") -> PersonListItem {
        PersonListItem(id: id, name: name, originalName: name, gender: .unknown)
    }

    static func company(id: Int, name: String) -> ProductionCompany {
        ProductionCompany(id: id, name: name, originCountry: "US")
    }

    static func genre(id: Int, name: String) -> Genre {
        Genre(id: id, name: name)
    }

    static func castMember(id: Int, name: String, order: Int = 0) -> CastMember {
        CastMember(id: id, creditID: "c\(id)", name: name, character: "Character", order: order)
    }

    static func crewMember(id: Int, name: String, job: String) -> CrewMember {
        CrewMember(id: id, creditID: "w\(id)", name: name, job: job, department: job)
    }

}
