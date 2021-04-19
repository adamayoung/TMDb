@testable import TMDb
import XCTest

class TVShowTests: XCTestCase {

    func testFirstAirDateWhenNilReturnsNil() {
        let someTVShow = TVShow(id: 1, name: "Some tv show name 1", firstAirDate: nil)

        XCTAssertNil(someTVShow.firstAirDate)
    }

    func testHomepageURLWhenNilReturnsNil() {
        let someTVShow = TVShow(id: 2, name: "Some tv show name 2", homepageURL: nil)

        XCTAssertNil(someTVShow.homepageURL)
    }

    func testHomepageURLWhenHasURLReturnsURL() {
        let expectedResult = URL(string: "https://some.domain.com")!
        let someTVShow = TVShow(id: 3, name: "Some tv show name 3", homepageURL: expectedResult)

        XCTAssertEqual(someTVShow.homepageURL, expectedResult)
    }

    func testDecodeReturnsTVShow() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(TVShow.self, from: data)

        XCTAssertEqual(result, tvShow)
    }

    func testSortNoDates() {
        let tvShowOne = TVShow(id: .randomID, name: .randomString)
        let tvShowTwo = TVShow(id: .randomID, name: .randomString)

        let result = tvShowOne < tvShowTwo

        XCTAssertFalse(result)
    }

    func testSortWithLHSDate() {
        let tvShowOne = TVShow(id: .randomID, name: .randomString,
                               firstAirDate: Date(timeIntervalSince1970: 1618840399))
        let tvShowTwo = TVShow(id: .randomID, name: .randomString)

        let result = tvShowOne < tvShowTwo

        XCTAssertTrue(result)
    }

    func testSortWithRHSDate() {
        let tvShowOne = TVShow(id: .randomID, name: .randomString)
        let tvShowTwo = TVShow(id: .randomID, name: .randomString,
                               firstAirDate: Date(timeIntervalSince1970: 1218840399))

        let result = tvShowOne < tvShowTwo

        XCTAssertFalse(result)
    }

    func testSortWithDates() {
        let tvShowOne = TVShow(id: .randomID, name: .randomString,
                               firstAirDate: Date(timeIntervalSince1970: 1618840399))
        let tvShowTwo = TVShow(id: .randomID, name: .randomString,
                               firstAirDate: Date(timeIntervalSince1970: 1218840399))

        let result = tvShowOne < tvShowTwo

        XCTAssertTrue(result)
    }

}

extension TVShowTests {

    // swiftlint:disable line_length
    private var json: String {
        """
        {
            "backdrop_path": "/gX8SYlnL9ZznfZwEH4KJUePBFUM.jpg",
            "created_by": [
                {
                    "id": 9813,
                    "credit_id": "5256c8c219c2956ff604858a",
                    "name": "David Benioff",
                    "gender": 2,
                    "profile_path": "/8CuuNIKMzMUL1NKOPv9AqEwM7og.jpg"
                },
                {
                    "id": 228068,
                    "credit_id": "552e611e9251413fea000901",
                    "name": "D. B. Weiss",
                    "gender": 2,
                    "profile_path": "/caUAtilEe06OwOjoQY3B7BgpARi.jpg"
                }
            ],
            "episode_run_time": [
                60
            ],
            "first_air_date": "2011-04-17",
            "genres": [
                {
                  "id": 10765,
                  "name": "Sci-Fi & Fantasy"
                },
                {
                  "id": 18,
                  "name": "Drama"
                },
                {
                  "id": 10759,
                  "name": "Action & Adventure"
                }
            ],
            "homepage": "http://www.hbo.com/game-of-thrones",
            "id": 1399,
            "in_production": true,
            "languages": [
                "es",
                "en",
                "de"
            ],
            "last_air_date": "2017-08-27",
            "last_episode_to_air": {
                "air_date": "2017-08-27",
                "episode_number": 7,
                "id": 1340528,
                "name": "The Dragon and the Wolf",
                "overview": "A meeting is held in King's Landing. Problems arise in the North.",
                "production_code": "707",
                "season_number": 7,
                "show_id": 1399,
                "still_path": "/jLe9VcbGRDUJeuM8IwB7VX4GDRg.jpg",
                "vote_average": 9.145,
                "vote_count": 31
            },
            "name": "Game of Thrones",
            "next_episode_to_air": null,
            "networks": [
                {
                  "name": "HBO",
                  "id": 49,
                  "logo_path": "/tuomPhY2UtuPTqqFnKMVHvSb724.png",
                  "origin_country": "US"
                }
            ],
            "number_of_episodes": 67,
            "number_of_seasons": 7,
            "origin_country": [
                "US"
            ],
            "original_language": "en",
            "original_name": "Game of Thrones",
            "overview": "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
            "popularity": 53.516,
            "poster_path": "/gwPSoYUHAKmdyVywgLpKKA4BjRr.jpg",
            "production_companies": [
                {
                  "id": 3268,
                  "logo_path": "/tuomPhY2UtuPTqqFnKMVHvSb724.png",
                  "name": "HBO",
                  "origin_country": "US"
                }
            ],
            "seasons": [
                {
                  "air_date": "2011-04-17",
                  "episode_count": 10,
                  "id": 3624,
                  "name": "Season 1",
                  "overview": "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.",
                  "poster_path": "/zwaj4egrhnXOBIit1tyb4Sbt3KP.jpg",
                  "season_number": 1
                }
            ],
            "status": "Returning Series",
            "type": "Scripted",
            "vote_average": 8.2,
            "vote_count": 4682
        }
        """
    }

    private var tvShow: TVShow {
        .init(
            id: 1399,
            name: "Game of Thrones",
            originalName: "Game of Thrones",
            originalLanguage: "en",
            overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
            episodeRunTime: [60],
            numberOfSeasons: 7,
            numberOfEpisodes: 67,
            seasons: [
                TVShowSeason(
                    id: 3624,
                    name: "Season 1",
                    seasonNumber: 1,
                    overview: "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.",
                    airDate: DateFormatter.theMovieDatabase.date(from: "2011-04-17"),
                    posterPath: URL(string: "/zwaj4egrhnXOBIit1tyb4Sbt3KP.jpg"),
                    episodes: nil
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
            inProduction: true,
            languages: ["es", "en", "de"],
            lastAirDate: DateFormatter.theMovieDatabase.date(from: "2017-08-27"),
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
            status: "Returning Series",
            type: "Scripted",
            popularity: 53.516,
            voteAverage: 8.2,
            voteCount: 4682
        )
    }
    // swiftlint:enable line_length

}
