//
//  TVSeriesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesTests {

    @Test("JSON decoding of TVSeries", .tags(.decoding))
    func decodeReturnsTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self, fromResource: "tv-series"
        )

        #expect(result == tvSeries)
    }

    @Test("JSON decoding of TVSeries with blank homepage and first air date")
    func decodeWhenHomepageIsEmptyStringReturnsTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self,
            fromResource: "tv-series-blank-homepage-first-air-date"
        )

        #expect(result.homepageURL == nil)
        #expect(result.firstAirDate == nil)
    }

    @Test("createdBy decodes correctly", .tags(.decoding))
    func createdByDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self, fromResource: "tv-series"
        )

        #expect(result.createdBy?.count == 2)
        #expect(result.createdBy?[0].id == 9813)
        #expect(result.createdBy?[0].creditID == "5256c8c219c2956ff604858a")
        #expect(result.createdBy?[0].name == "David Benioff")
        #expect(result.createdBy?[0].originalName == "David Benioff")
        #expect(result.createdBy?[0].gender == .male)
        #expect(result.createdBy?[0].profilePath == URL(string: "/xvNN5huL0X8yJ7h3IZfGG4O2zBD.jpg"))

        #expect(result.createdBy?[1].id == 228_068)
        #expect(result.createdBy?[1].creditID == "552e611e9251413fea000901")
        #expect(result.createdBy?[1].name == "D. B. Weiss")
        #expect(result.createdBy?[1].originalName == "D. B. Weiss")
        #expect(result.createdBy?[1].gender == .male)
        #expect(result.createdBy?[1].profilePath == URL(string: "/6Wt006TIQoDSSnl0YaKihfn3w7K.jpg"))
    }

    @Test("lastEpisodeToAir decodes correctly", .tags(.decoding))
    func lastEpisodeToAirDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self, fromResource: "tv-series"
        )

        #expect(result.lastEpisodeToAir != nil)
        let episode = try #require(result.lastEpisodeToAir)
        #expect(episode.id == 1_340_528)
        #expect(episode.name == "The Dragon and the Wolf")
        #expect(episode.episodeNumber == 7)
        #expect(episode.seasonNumber == 7)
        #expect(
            episode.overview == "A meeting is held in King's Landing. Problems arise in the North."
        )
        #expect(episode.airDate == DateFormatter.theMovieDatabase.date(from: "2017-08-27"))
        #expect(episode.productionCode == "707")
        #expect(episode.showID == 1399)
        #expect(episode.stillPath == URL(string: "/jLe9VcbGRDUJeuM8IwB7VX4GDRg.jpg"))
        #expect(episode.voteAverage == 9.145)
        #expect(episode.voteCount == 31)
    }

    @Test("productionCountries decodes correctly", .tags(.decoding))
    func productionCountriesDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self, fromResource: "tv-series"
        )

        let productionCountries = try #require(result.productionCountries)
        #expect(productionCountries.count == 1)
        #expect(productionCountries[0].countryCode == "US")
        #expect(productionCountries[0].name == "United States of America")
    }

    @Test("spokenLanguages decodes correctly", .tags(.decoding))
    func spokenLanguagesDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self, fromResource: "tv-series"
        )

        let spokenLanguages = try #require(result.spokenLanguages)
        #expect(spokenLanguages.count == 1)
        #expect(spokenLanguages[0].languageCode == "en")
        #expect(spokenLanguages[0].name == "English")
    }

    @Test("nextEpisodeToAir decodes correctly when null")
    func nextEpisodeToAirDecodesNull() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self, fromResource: "tv-series"
        )

        #expect(result.nextEpisodeToAir == nil)
    }

}

extension TVSeriesTests {

    private var tvSeries: TVSeries {
        .init(
            id: 1399,
            name: "Game of Thrones",
            originalName: "Game of Thrones",
            originalLanguage: "en",
            // swiftlint:disable:next line_length
            overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
            episodeRunTime: [60],
            numberOfSeasons: 7,
            numberOfEpisodes: 67,
            seasons: [
                TVSeason(
                    id: 3624,
                    name: "Season 1",
                    seasonNumber: 1,
                    // swiftlint:disable:next line_length
                    overview: "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.",
                    airDate: DateFormatter.theMovieDatabase.date(from: "2011-04-17"),
                    posterPath: URL(string: "/zwaj4egrhnXOBIit1tyb4Sbt3KP.jpg"),
                    episodes: nil
                )
            ],
            createdBy: [
                Creator(
                    id: 9813,
                    creditID: "5256c8c219c2956ff604858a",
                    name: "David Benioff",
                    originalName: "David Benioff",
                    gender: .male,
                    profilePath: URL(string: "/xvNN5huL0X8yJ7h3IZfGG4O2zBD.jpg")
                ),
                Creator(
                    id: 228_068,
                    creditID: "552e611e9251413fea000901",
                    name: "D. B. Weiss",
                    originalName: "D. B. Weiss",
                    gender: .male,
                    profilePath: URL(string: "/6Wt006TIQoDSSnl0YaKihfn3w7K.jpg")
                )
            ],
            genres: [
                Genre(id: 10765, name: "Sci-Fi & Fantasy"),
                Genre(id: 18, name: "Drama"),
                Genre(id: 10759, name: "Action & Adventure")
            ],
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2011-04-17"),
            originCountry: ["US"],
            posterPath: URL(string: "/gwPSoYUHAKmdyVywgLpKKA4BjRr.jpg"),
            backdropPath: URL(string: "/gX8SYlnL9ZznfZwEH4KJUePBFUM.jpg"),
            homepageURL: URL(string: "http://www.hbo.com/game-of-thrones"),
            isInProduction: true,
            languages: ["es", "en", "de"],
            lastAirDate: DateFormatter.theMovieDatabase.date(from: "2017-08-27"),
            lastEpisodeToAir: TVEpisodeAirDate(
                id: 1_340_528,
                name: "The Dragon and the Wolf",
                episodeNumber: 7,
                seasonNumber: 7,
                overview: "A meeting is held in King's Landing. Problems arise in the North.",
                airDate: DateFormatter.theMovieDatabase.date(from: "2017-08-27"),
                episodeType: nil,
                runtime: nil,
                showID: 1399,
                productionCode: "707",
                stillPath: URL(string: "/jLe9VcbGRDUJeuM8IwB7VX4GDRg.jpg"),
                voteAverage: 9.145,
                voteCount: 31
            ),
            nextEpisodeToAir: nil,
            networks: [
                Network(
                    id: 49,
                    name: "HBO",
                    logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
                    originCountry: "US"
                )
            ],
            productionCompanies: [
                ProductionCompany(
                    id: 3268,
                    name: "HBO",
                    originCountry: "US",
                    logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png")
                )
            ],
            productionCountries: [
                ProductionCountry(
                    countryCode: "US",
                    name: "United States of America"
                )
            ],
            spokenLanguages: [
                SpokenLanguage(
                    languageCode: "en",
                    name: "English"
                )
            ],
            status: "Returning Series",
            type: "Scripted",
            popularity: 53.516,
            voteAverage: 8.2,
            voteCount: 4682,
            isAdultOnly: false
        )
    }

}
