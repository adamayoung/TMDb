@testable import TMDb
import XCTest

final class TVShowSeasonTests: XCTestCase {

    func testDecodeReturnsTVShowSeason() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(TVShowSeason.self, fromResource: "tv-show-season")

        XCTAssertEqual(result.id, tvShowSeason.id)
        XCTAssertEqual(result.name, tvShowSeason.name)
        XCTAssertEqual(result.seasonNumber, tvShowSeason.seasonNumber)
        XCTAssertEqual(result.overview, tvShowSeason.overview)
        XCTAssertEqual(result.airDate, tvShowSeason.airDate)
        XCTAssertEqual(result.posterPath, tvShowSeason.posterPath)
        XCTAssertEqual(result.episodes, tvShowSeason.episodes)
    }

    // swiftlint:disable line_length
    private let tvShowSeason = TVShowSeason(
        id: 3624,
        name: "Season 1",
        seasonNumber: 1,
        overview: "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.",
        airDate: DateFormatter.theMovieDatabase.date(from: "2011-04-17"),
        posterPath: URL(string: "/zwaj4egrhnXOBIit1tyb4Sbt3KP.jpg"),
        episodes: nil
    )
    // swiftlint:enable line_length

}
