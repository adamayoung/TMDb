import Combine
import Foundation

public final class TMDbAPI {

    public static let shared = TMDbAPI()

    private let certificationService: CertificationService
    private let configurationService: ConfigurationService
    private let discoverService: DiscoverService
    private let movieService: MovieService
    private let personService: PersonService
    private let searchService: SearchService
    private let trendingService: TrendingService
    private let tvShowService: TVShowService
    private let tvShowSeasonService: TVShowSeasonService

    init(
        certificationService: CertificationService = TMDbCertificationService(),
        configurationService: ConfigurationService = TMDbConfigurationService(),
        discoverService: DiscoverService = TMDbDiscoverService(),
        movieService: MovieService = TMDbMovieService(),
        personService: PersonService = TMDbPersonService(),
        searchService: SearchService = TMDbSearchService(),
        trendingService: TrendingService = TMDbTrendingService(),
        tvShowService: TVShowService = TMDbTVShowService(),
        tvShowSeasonService: TVShowSeasonService = TMDbTVShowSeasonService()
    ) {
        self.certificationService = certificationService
        self.configurationService = configurationService
        self.discoverService = discoverService
        self.movieService = movieService
        self.personService = personService
        self.searchService = searchService
        self.trendingService = trendingService
        self.tvShowService = tvShowService
        self.tvShowSeasonService = tvShowSeasonService
    }

    public static func setAPIKey(_ apiKey: String) {
        TMDbAPIClient.setAPIKey(apiKey)
    }

}

extension TMDbAPI {

    public func movieCertificationsPublisher() -> AnyPublisher<[String: [CertificationDTO]], TMDbError> {
        certificationService.fetchMovieCertifications()
    }

    public func tvShowCertificationsPublisher() -> AnyPublisher<[String: [CertificationDTO]], TMDbError> {
        certificationService.fetchTVShowCertifications()
    }

}

extension TMDbAPI {

    public func apiConfigurationPublisher() -> AnyPublisher<APIConfigurationDTO, TMDbError> {
        configurationService.fetchAPIConfiguration()
    }

}

extension TMDbAPI {

    public func discoverMoviesPublisher(sortBy: MovieSortBy? = .default, withPeople: [PersonDTO.ID]? = nil,
                                        page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        discoverService.fetchMovies(sortBy: sortBy, withPeople: withPeople, page: page)
    }

    public func discoverTVShowsPublisher(sortBy: TVShowSortBy? = .default,
                                         page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        discoverService.fetchTVShows(sortBy: sortBy, page: page)
    }

}

extension TMDbAPI {

    public func detailsPublisher(forMovie id: MovieDTO.ID) -> AnyPublisher<MovieDTO, TMDbError> {
        movieService.fetchDetails(forMovie: id)
    }

    public func creditsPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        movieService.fetchCredits(forMovie: movieID)
    }

    public func reviewsPublisher(forMovie movieID: MovieDTO.ID,
                                 page: Int? = nil) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
        movieService.fetchReviews(forMovie: movieID, page: page)
    }

    public func imagesPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
        movieService.fetchImages(forMovie: movieID)
    }

    public func videosPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
        movieService.fetchVideos(forMovie: movieID)
    }

    public func recommendationsPublisher(forMovie movieID: MovieDTO.ID,
                                         page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        movieService.fetchRecommendations(forMovie: movieID, page: page)
    }

    public func moviesPublisher(similarToMovie movieID: MovieDTO.ID,
                                page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        movieService.fetchSimilar(toMovie: movieID, page: page)
    }

    public func popularMoviesPublisher(page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        movieService.fetchPopular(page: page)
    }

}

extension TMDbAPI {

    public func detailsPublisher(forPerson id: PersonDTO.ID) -> AnyPublisher<PersonDTO, TMDbError> {
        personService.fetchDetails(forPerson: id)
    }

    public func combinedCreditsPublisher(
        forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonCombinedCreditsDTO, TMDbError> {
        personService.fetchCombinedCredits(forPerson: personID)
    }

    public func movieCreditsPublisher(
        forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonMovieCreditsDTO, TMDbError> {
        personService.fetchMovieCredits(forPerson: personID)
    }

    public func tvShowCredits(
        forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonTVShowCreditsDTO, TMDbError> {
        personService.fetchTVShowCredits(forPerson: personID)
    }

    public func imagesPublisher(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonImageCollectionDTO, TMDbError> {
        personService.fetchImages(forPerson: personID)
    }

    public func knownForPublisher(forPerson personID: PersonDTO.ID) -> AnyPublisher<[ShowDTO], TMDbError> {
        personService.fetchKnownFor(forPerson: personID)
    }

    public func popularPeoplePublisher(page: Int? = nil) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        personService.fetchPopular(page: page)
    }

}

extension TMDbAPI {

    public func searchPublisher(withQuery query: String,
                                page: Int? = nil) -> AnyPublisher<MediaPageableListDTO, TMDbError> {
        searchService.searchAll(query: query, page: page)
    }

    public func searchMoviesPublisher(withQuery query: String, year: Int? = nil,
                                      page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        searchService.searchMovies(query: query, year: year, page: page)
    }

    public func searchTVShowsPublisher(withQuery query: String, firstAirDateYear: Int? = nil,
                                       page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        searchService.searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    public func searchPeoplePublisher(withQuery query: String,
                                      page: Int? = nil) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        searchService.searchPeople(query: query, page: page)
    }

}

extension TMDbAPI {

    public func trendingMoviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                        page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        trendingService.fetchMovies(timeWindow: timeWindow, page: page)
    }

    public func trendingTVShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                         page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        trendingService.fetchTVShows(timeWindow: timeWindow, page: page)
    }

    public func trendingPeoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                        page: Int? = nil) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        trendingService.fetchPeople(timeWindow: timeWindow, page: page)
    }

}

extension TMDbAPI {

    public func detailsPublisher(forTVShow id: TVShowDTO.ID) -> AnyPublisher<TVShowDTO, TMDbError> {
        tvShowService.fetchDetails(forTVShow: id)
    }

    public func creditsPublisher(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        tvShowService.fetchCredits(forTVShow: tvShowID)
    }

    public func reviewsPublisher(forTVShow tvShowID: TVShowDTO.ID,
                                 page: Int? = nil) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
        tvShowService.fetchReviews(forTVShow: tvShowID, page: page)
    }

    public func imagesPublisher(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
        tvShowService.fetchImages(forTVShow: tvShowID)
    }

    public func videosPublisher(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
        tvShowService.fetchVideos(forTVShow: tvShowID)
    }

    public func recommendationsPublisher(forTVShow tvShowID: TVShowDTO.ID,
                                         page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        tvShowService.fetchRecommendations(forTVShow: tvShowID, page: page)
    }

    public func tvShowsPublisher(similarToTVShow tvShowID: TVShowDTO.ID,
                                 page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        tvShowService.fetchSimilar(toTVShow: tvShowID, page: page)
    }

    public func popularTVShowsPublisher(page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        tvShowService.fetchPopular(page: page)
    }

}

extension TMDbAPI {

    public func detailsPublisher(forSeason seasonNumber: Int,
                                 inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<TVShowSeasonDTO, TMDbError> {
        tvShowSeasonService.fetchDetails(forSeason: seasonNumber, inTVShow: tvShowID)
    }

    public func imagesPublisher(forSeason seasonNumber: Int,
                                inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
        tvShowSeasonService.fetchImages(forSeason: seasonNumber, inTVShow: tvShowID)
    }

    public func videosPublisher(forSeason seasonNumber: Int,
                                inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
        tvShowSeasonService.fetchVideos(forSeason: seasonNumber, inTVShow: tvShowID)
    }

}
