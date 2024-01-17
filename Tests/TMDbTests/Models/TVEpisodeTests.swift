//
//  TVEpisodeTests.swift
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

final class TVTests: XCTestCase {

    func testDecodeReturnsTVEpisode() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(TVEpisode.self, fromResource: "tv-episode")

        XCTAssertEqual(result.id, tvEpisode.id)
        XCTAssertEqual(result.name, tvEpisode.name)
        XCTAssertEqual(result.episodeNumber, tvEpisode.episodeNumber)
        XCTAssertEqual(result.seasonNumber, tvEpisode.seasonNumber)
        XCTAssertEqual(result.overview, tvEpisode.overview)
        XCTAssertEqual(result.airDate, tvEpisode.airDate)
        XCTAssertEqual(result.productionCode, tvEpisode.productionCode)
        XCTAssertEqual(result.stillPath, tvEpisode.stillPath)
        XCTAssertEqual(result.crew, tvEpisode.crew)
        XCTAssertEqual(result.guestStars, tvEpisode.guestStars)
        XCTAssertEqual(result.voteAverage, tvEpisode.voteAverage)
        XCTAssertEqual(result.voteCount, tvEpisode.voteCount)
    }

    // swiftlint:disable line_length
    private let tvEpisode = TVEpisode(
        id: 63056,
        name: "Winter Is Coming",
        episodeNumber: 1,
        seasonNumber: 1,
        overview: "Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.",
        airDate: DateFormatter.theMovieDatabase.date(from: "2011-04-17"),
        productionCode: "101",
        stillPath: URL(string: "/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg"),
        crew: [
            CrewMember(
                id: 44797,
                creditID: "5256c8a219c2956ff6046e77",
                name: "Tim Van Patten",
                job: "Director",
                department: "Directing",
                profilePath: URL(string: "/6b7l9YbkDHDOzOKUFNqBVaPjcgm.jpg")
            )
        ],
        guestStars: [
            CastMember(
                id: 117_642,
                creditID: "5256c8a219c2956ff6046f40",
                name: "Jason Momoa",
                character: "Khal Drogo",
                profilePath: URL(string: "/PSK6GmsVwdhqz9cd1lwzC6a7EA.jpg"),
                order: 0
            )
        ],
        voteAverage: 7.11904761904762,
        voteCount: 21
    )
    // swiftlint:enable line_length

}
