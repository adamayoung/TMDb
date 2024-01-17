//
//  TVSeriesTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import TMDb
import XCTest

final class TVSeriesTests: XCTestCase {

    func testDecodeReturnsTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(TVSeries.self, fromResource: "tv-series")

        XCTAssertEqual(result, tvSeries)
    }

    func testDecodeWhenHomepageIsEmptyStringReturnsTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeries.self,
            fromResource: "tv-series-blank-homepage-first-air-date"
        )

        XCTAssertNil(result.homepageURL)
        XCTAssertNil(result.firstAirDate)
    }

}

extension TVSeriesTests {

    // swiftlint:disable line_length
    private var tvSeries: TVSeries {
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
                TVSeason(
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
            isInProduction: true,
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
            voteCount: 4682,
            isAdultOnly: false
        )
    }
    // swiftlint:enable line_length

}
