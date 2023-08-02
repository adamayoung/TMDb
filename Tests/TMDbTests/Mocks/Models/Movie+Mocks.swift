import Foundation
@testable import TMDb

extension Movie {

    static func mock(
        id: Int = Int.randomID,
        title: String? = nil,
        tagline: String? = .randomString,
        originalTitle: String? = nil,
        originalLanguage: String? = "en",
        overview: String? = .randomString,
        runtime: Int? = Int.random(in: 60...240),
        genres: [Genre]? = .mocks,
        releaseDate: Date? = .random,
        posterPath: URL? = .randomImagePath,
        backdropPath: URL? = .randomImagePath,
        budget: Double? = Double.random(in: 1000000...65000000),
        revenue: Double? = Double.random(in: 1000000...65000000),
        homepageURL: URL? = .randomWebSite,
        imdbID: String? = .randomID,
        status: Status? = .released,
        productionCompanies: [ProductionCompany]? = .mocks,
        productionCountries: [ProductionCountry]? = .mocks,
        spokenLanguages: [SpokenLanguage]? = .mocks,
        popularity: Double? = Double.random(in: 1...10),
        voteAverage: Double? = Double.random(in: 1...10),
        voteCount: Int? = Int.random(in: 1...1000),
        hasVideo: Bool? = .random(),
        isAdultOnly: Bool? = .random()
    ) -> Self {
        .init(
            id: id,
            title: title ?? "Movie \(id)",
            tagline: tagline,
            originalTitle: originalTitle ?? title ?? "Movie \(id)",
            originalLanguage: originalLanguage,
            overview: overview,
            runtime: runtime,
            genres: genres,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            budget: budget,
            revenue: revenue,
            homepageURL: homepageURL,
            imdbID: imdbID,
            status: status,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: spokenLanguages,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            hasVideo: hasVideo,
            isAdultOnly: isAdultOnly
        )
    }

    static var bulletTrain: Self {
        .mock(
            id: 718930,
            title: "Bullet Train",
            overview: "Unlucky assassin Ladybug is determined to do his job peacefully after one too many gigs gone "
            + "off the rails. Fate, however, may have other plans, as Ladybug's latest mission puts him on a collision "
            + "course with lethal adversaries from around the globe—all with connected, yet conflicting, objectives—on "
            + "the world's fastest train.",
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-07-03")
        )
    }

    static var thorLoveAndThunder: Self {
        .mock(
            id: 616037,
            title: "Thor: Love and Thunder",
            overview: "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the "
            + "extinction of the gods, Thor Odinson enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane "
            + "Foster, who now inexplicably wields Mjolnir as the Relatively Mighty Girl Thor. Together they embark "
            + "upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him "
            + "before it’s too late.",
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-07-06")
        )
    }

    static var jurassicWorldDominion: Self {
        .mock(
            id: 507086,
            title: "Jurassic World Dominion",
            overview: "Four years after Isla Nublar was destroyed, dinosaurs now live—and hunt—alongside humans all "
            + "over the world. This fragile balance will reshape the future and determine, once and for all, whether "
            + "human beings are to remain the apex predators on a planet they now share with history’s most fearsome "
            + "creatures.",
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-06-01")
        )
    }

    static var topGunMaverick: Self {
        .mock(
            id: 361743,
            title: "Top Gun: Maverick",
            overview: "After more than thirty years of service as one of the Navy’s top aviators, and dodging the "
            + "advancement in rank that would ground him, Pete “Maverick” Mitchell finds himself training a detachment "
            + "of TOP GUN graduates for a specialized mission the likes of which no living pilot has ever seen.",
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-05-24")
        )
    }

}

extension Array where Element == Movie {

    static var mocks: [Element] {
        [
            .bulletTrain,
            .thorLoveAndThunder,
            .jurassicWorldDominion,
            .topGunMaverick
        ]
    }

}
