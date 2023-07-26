@testable import TMDb
import XCTest

final class MovieTests: XCTestCase {

    func testReleaseDateWhenNilReturnsNil() {
        let someMovie = Movie(id: 1, title: "Some movie title 1")

        XCTAssertNil(someMovie.releaseDate)
    }

    func testHomepageURLWhenNilReturnsNil() {
        let someMovie = Movie(id: 2, title: "Some movie title 2")

        XCTAssertNil(someMovie.homepageURL)
    }

    func testHomepageURLWhenHasURLReturnsURL() throws {
        let expectedResult = try XCTUnwrap(URL(string: "https://some.domain.com"))
        let someMovie = Movie(id: 3, title: "Some movie title 3", homepageURL: expectedResult)

        XCTAssertEqual(someMovie.homepageURL, expectedResult)
    }

    func testDecodeReturnsMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Movie.self, fromResource: "movie")

        XCTAssertEqual(result, movie)
    }

    func testSortWithNoDates() {
        let movieOne = Movie(id: .randomID, title: .randomString)
        let movieTwo = Movie(id: .randomID, title: .randomString)

        let result = movieOne < movieTwo

        XCTAssertFalse(result)
    }

    func testSortWithLHSDate() {
        let movieOne = Movie(id: .randomID, title: .randomString, releaseDate: Date(timeIntervalSince1970: 1618840399))
        let movieTwo = Movie(id: .randomID, title: .randomString)

        let result = movieOne < movieTwo

        XCTAssertTrue(result)
    }

    func testSortWithRHSDate() {
        let movieOne = Movie(id: .randomID, title: .randomString)
        let movieTwo = Movie(id: .randomID, title: .randomString, releaseDate: Date(timeIntervalSince1970: 1218840399))

        let result = movieOne < movieTwo

        XCTAssertFalse(result)
    }

    func testSortWithDates() {
        let movieOne = Movie(id: .randomID, title: .randomString, releaseDate: Date(timeIntervalSince1970: 1618840399))
        let movieTwo = Movie(id: .randomID, title: .randomString, releaseDate: Date(timeIntervalSince1970: 1218840399))

        let result = movieOne < movieTwo

        XCTAssertTrue(result)
    }

}

extension MovieTests {

    // swiftlint:disable line_length
    private var movie: Movie {
        .init(
            id: 550,
            title: "Fight Club",
            tagline: "How much can you know about yourself if you've never been in a fight?",
            originalTitle: "Fight Club",
            originalLanguage: "en",
            overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
            runtime: 139,
            genres: [
                Genre(id: 18, name: "Drama")
            ],
            releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-12"),
            posterPath: nil,
            backdropPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"),
            budget: 63000000,
            revenue: 100853753,
            homepageURL: URL(string: ""),
            imdbID: "tt0137523",
            status: .released,
            productionCompanies: [
                ProductionCompany(
                    id: 508,
                    name: "Regency Enterprises",
                    originCountry: "US",
                    logoPath: URL(string: "/7PzJdsLGlR7oW4J0J5Xcd0pHGRg.png")
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
            popularity: 0.5,
            voteAverage: 7.8,
            voteCount: 3439,
            video: false,
            adult: false
        )
    }
    // swiftlint:enable line_length

}
