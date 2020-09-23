import Combine
@testable import TMDb
import XCTest

class TMDbAPITestCase: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

}
