@testable import TMDb
import XCTest

final class TMDbAPITests: XCTestCase {

    var tmdb: TMDbAPI!
    var certificationService: MockCertificationService!
    var configurationService: MockConfigurationService!
    var discoverService: MockDiscoverService!
    var movieService: MockMovieService!
    var personService: MockPersonService!
    var searchService: MockSearchService!
    var trendingService: MockTrendingService!
    var tvShowService: MockTVShowService!
    var tvShowSeasonService: MockTVShowSeasonService!

    override func setUp() {
        super.setUp()
        certificationService = MockCertificationService()
        configurationService = MockConfigurationService()
        discoverService = MockDiscoverService()
        movieService = MockMovieService()
        personService = MockPersonService()
        searchService = MockSearchService()
        trendingService = MockTrendingService()
        tvShowService = MockTVShowService()
        tvShowSeasonService = MockTVShowSeasonService()
        tmdb = TMDbAPI(
            certificationService: certificationService,
            configurationService: configurationService,
            discoverService: discoverService,
            movieService: movieService,
            personService: personService,
            searchService: searchService,
            trendingService: trendingService,
            tvShowService: tvShowService,
            tvShowSeasonService: tvShowSeasonService
        )
    }

    override func tearDown() {
        certificationService = nil
        configurationService = nil
        discoverService = nil
        movieService = nil
        personService = nil
        searchService = nil
        trendingService = nil
        tvShowService = nil
        tvShowSeasonService = nil
        tmdb = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertIdentical(tmdb.certifications as? MockCertificationService, certificationService)
        XCTAssertIdentical(tmdb.configurations as? MockConfigurationService, configurationService)
        XCTAssertIdentical(tmdb.discover as? MockDiscoverService, discoverService)
        XCTAssertIdentical(tmdb.movies as? MockMovieService, movieService)
        XCTAssertIdentical(tmdb.people as? MockPersonService, personService)
        XCTAssertIdentical(tmdb.search as? MockSearchService, searchService)
        XCTAssertIdentical(tmdb.trending as? MockTrendingService, trendingService)
        XCTAssertIdentical(tmdb.tvShows as? MockTVShowService, tvShowService)
        XCTAssertIdentical(tmdb.tvShowSeasons as? MockTVShowSeasonService, tvShowSeasonService)
    }

}
