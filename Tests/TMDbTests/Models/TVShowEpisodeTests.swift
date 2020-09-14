@testable import TMDb
import XCTest

class TVShowEpisodeTests: XCTestCase {

    func testDecode_returnsTVShowEpisode() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(TVShowEpisode.self, from: data)

        XCTAssertEqual(result, tvShowEpisode)
    }

    private let json = """
    {
        "air_date": "2011-04-17",
        "crew": [
            {
                "id": 44797,
                "credit_id": "5256c8a219c2956ff6046e77",
                "name": "Tim Van Patten",
                "department": "Directing",
                "job": "Director",
                "profile_path": "/6b7l9YbkDHDOzOKUFNqBVaPjcgm.jpg"
            }
        ],
        "episode_number": 1,
        "guest_stars": [
            {
                "id": 117642,
                "name": "Jason Momoa",
                "credit_id": "5256c8a219c2956ff6046f40",
                "character": "Khal Drogo",
                "order": 0,
                "profile_path": "/PSK6GmsVwdhqz9cd1lwzC6a7EA.jpg"
            },
        ],
        "name": "Winter Is Coming",
        "overview": "Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.",
        "id": 63056,
        "production_code": "101",
        "season_number": 1,
        "still_path": "/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg",
        "vote_average": 7.11904761904762,
        "vote_count": 21
    }
    """

    private let tvShowEpisode = TVShowEpisode(
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
                id: 117642,
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

}
