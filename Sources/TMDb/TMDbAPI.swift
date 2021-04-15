import Combine
import Foundation

/// The Movie Database API.
///
/// - Note: [The Movie Database API Documentation](https://developers.themoviedb.org)
public final class TMDbAPI: MovieTVShowAPI {

    /// A shared instance of the TMDb API.
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

    /// Sets the TMDb API Key to be used with requests to the TMDb API.
    ///
    /// - Note: [TMDb API - Getting Started: Authentication](https://developers.themoviedb.org/3/getting-started/authentication#api-key)
    ///
    /// - Parameter apiKey: The TMDb API Key.
    public static func setAPIKey(_ apiKey: String) {
        TMDbAPIClient.setAPIKey(apiKey)
    }

}

extension TMDbAPI {

    /// Publishes the officially supported movie certifications on TMDb.
    ///
    /// - Note: [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    public func movieCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        certificationService.fetchMovieCertifications()
    }

    /// Publishes the officially supported TV show certifications on TMDb.
    ///
    /// - Note: [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    public func tvShowCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        certificationService.fetchTVShowCertifications()
    }

}

extension TMDbAPI {

    /// Publishes the TMDb API system wide configuration information.
    ///
    /// - Note: [TMDb API - Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    public func apiConfigurationPublisher() -> AnyPublisher<APIConfiguration, TMDbError> {
        configurationService.fetchAPIConfiguration()
    }

}

extension TMDbAPI {

    /// Publishes movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Parameter sortBy: How results should be sorted.
    /// - Parameter withPeople: A list of Person IDs which to return only movies they have appeared in.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func discoverMoviesPublisher(sortBy: MovieSortBy? = .default, withPeople: [Person.ID]? = nil,
                                        page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        discoverService.fetchMovies(sortBy: sortBy, withPeople: withPeople, page: page)
    }

    /// Publishes TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Parameter sortBy: How results should be sorted.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func discoverTVShowsPublisher(sortBy: TVShowSortBy? = .default,
                                         page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        discoverService.fetchTVShows(sortBy: sortBy, page: page)
    }

}

extension TMDbAPI {

    /// Publishes the primary information about a movie.
    ///
    /// - Note: [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameter id: The ID of the movie.
    public func detailsPublisher(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError> {
        movieService.fetchDetails(forMovie: id)
    }

    /// Publishes the cast and crew of a movie.
    ///
    /// - Note: [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameter movieID: The ID of the movie.
    public func creditsPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        movieService.fetchCredits(forMovie: movieID)
    }

    /// Publishes the user reviews for a movie.
    ///
    /// - Note: [TMDb API - Movie: Reviews](https://developers.themoviedb.org/3/movies/get-movie-reviews)
    ///
    /// - Parameter movieID: The ID of the movie.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func reviewsPublisher(forMovie movieID: Movie.ID,
                                 page: Int? = nil) -> AnyPublisher<ReviewPageableList, TMDbError> {
        movieService.fetchReviews(forMovie: movieID, page: page)
    }

    /// Publishes the images that belong to a movie.
    ///
    /// - Note: [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameter movieID: The ID of the movie.
    public func imagesPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        movieService.fetchImages(forMovie: movieID)
    }

    /// Publishes the videos that have been added to a movie.
    ///
    /// - Note: [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameter movieID: The ID of the movie.
    public func videosPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        movieService.fetchVideos(forMovie: movieID)
    }

    /// Publishes a list of recommended movies for a movie.
    ///
    /// - Note: [TMDb API - Movie: Recommendations](https://developers.themoviedb.org/3/movies/get-movie-recommendations)
    ///
    /// - Parameter movieID: The ID of the movie for get recommendations for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func recommendationsPublisher(forMovie movieID: Movie.ID,
                                         page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        movieService.fetchRecommendations(forMovie: movieID, page: page)
    }

    /// Publishes a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// - Note: [TMDb API - Movie: Similar](https://developers.themoviedb.org/3/movies/get-similar-movies)
    ///
    /// - Parameter movieID: The ID of the movie for get similar movies for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func moviesPublisher(similarToMovie movieID: Movie.ID,
                                page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        movieService.fetchSimilar(toMovie: movieID, page: page)
    }

    /// Publishes a list current popular movies.
    ///
    /// - Note: [TMDb API - Movie: Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
    ///
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func popularMoviesPublisher(page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        movieService.fetchPopular(page: page)
    }

}

extension TMDbAPI {

    /// Publishes the primary information about a person.
    ///
    /// - Note: [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameter id: The ID of the person.
    public func detailsPublisher(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError> {
        personService.fetchDetails(forPerson: id)
    }

    /// Publishes the combine movie and TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameter id: The ID of the person.
    public func combinedCreditsPublisher(
        forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError> {
        personService.fetchCombinedCredits(forPerson: personID)
    }

    /// Publishes the movie credits of a person.
    ///
    /// - Note: [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameter id: The ID of the person.
    public func movieCreditsPublisher(
        forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError> {
        personService.fetchMovieCredits(forPerson: personID)
    }

    /// Publishes the TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameter id: The ID of the person.
    public func tvShowCredits(
        forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError> {
        personService.fetchTVShowCredits(forPerson: personID)
    }

    /// Publishes the images for a person.
    ///
    /// - Note: [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameter id: The ID of the person.
    public func imagesPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError> {
        personService.fetchImages(forPerson: personID)
    }

    /// Publishes the list of known for shows for a person.
    ///
    /// - Parameter id: The ID of the person.
    public func knownForPublisher(forPerson personID: Person.ID) -> AnyPublisher<[Show], TMDbError> {
        personService.fetchKnownFor(forPerson: personID)
    }

    /// Publishes the list of popular people.
    ///
    /// - Note: [TMDb API - People: Popular](https://developers.themoviedb.org/3/people/get-popular-people)
    ///
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func popularPeoplePublisher(page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        personService.fetchPopular(page: page)
    }

}

extension TMDbAPI {

    /// Publishes search results for movies, TV shows and people based on a query..
    ///
    /// - Note: [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func searchPublisher(withQuery query: String,
                                page: Int? = nil) -> AnyPublisher<MediaPageableList, TMDbError> {
        searchService.searchAll(query: query, page: page)
    }

    /// Publishes search results for movies.
    ///
    /// - Note: [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter year: The year to filter results for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    public func searchMoviesPublisher(withQuery query: String, year: Int? = nil,
                                      page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        searchService.searchMovies(query: query, year: year, page: page)
    }

    /// Publishes search results for TV shows.
    ///
    /// - Note: [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter firstAirDateYear: The year of first air date to filter results for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    public func searchTVShowsPublisher(withQuery query: String, firstAirDateYear: Int? = nil,
                                       page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        searchService.searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    /// Publishes search results for people.
    ///
    /// - Note: [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    public func searchPeoplePublisher(withQuery query: String,
                                      page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        searchService.searchPeople(query: query, page: page)
    }

}

extension TMDbAPI {

    /// Publishes a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Parameter timeWindow: Daily or weekly time window.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    public func trendingMoviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                        page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        trendingService.fetchMovies(timeWindow: timeWindow, page: page)
    }

    /// Publishes a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Parameter timeWindow: Daily or weekly time window.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    public func trendingTVShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                         page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        trendingService.fetchTVShows(timeWindow: timeWindow, page: page)
    }

    /// Publishes a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Parameter timeWindow: Daily or weekly time window.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    public func trendingPeoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                        page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        trendingService.fetchPeople(timeWindow: timeWindow, page: page)
    }

}

extension TMDbAPI {

    /// Publishes the primary information about a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameter id: The ID of the TV show.
    public func detailsPublisher(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError> {
        tvShowService.fetchDetails(forTVShow: id)
    }

    /// Publishes the cast and crew of a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    public func creditsPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        tvShowService.fetchCredits(forTVShow: tvShowID)
    }

    /// Publishes the user reviews for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func reviewsPublisher(forTVShow tvShowID: TVShow.ID,
                                 page: Int? = nil) -> AnyPublisher<ReviewPageableList, TMDbError> {
        tvShowService.fetchReviews(forTVShow: tvShowID, page: page)
    }

    /// Publishes the images that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    public func imagesPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        tvShowService.fetchImages(forTVShow: tvShowID)
    }

    /// Publishes the videos that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    public func videosPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        tvShowService.fetchVideos(forTVShow: tvShowID)
    }

    /// Publishes a list of recommended TV shows for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func recommendationsPublisher(forTVShow tvShowID: TVShow.ID,
                                         page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowService.fetchRecommendations(forTVShow: tvShowID, page: page)
    }

    /// Publishes a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// - Note: [TMDb API - TV: Similar](https://developers.themoviedb.org/3/tv/get-tv-movies)
    ///
    /// - Parameter tvShowID: The ID of the TV show for get similar TV shows for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func tvShowsPublisher(similarToTVShow tvShowID: TVShow.ID,
                                 page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowService.fetchSimilar(toTVShow: tvShowID, page: page)
    }

    /// Publishes a list current popular TV shows.
    ///
    /// - Note: [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    public func popularTVShowsPublisher(page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowService.fetchPopular(page: page)
    }

}

extension TMDbAPI {

    /// Publishes the primary information about a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Details](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-details)
    ///
    /// - Parameter seasonNumber: The season number of a TV show.
    /// - Parameter tvShowID: The ID of the TV show.
    public func detailsPublisher(forSeason seasonNumber: Int,
                                 inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError> {
        tvShowSeasonService.fetchDetails(forSeason: seasonNumber, inTVShow: tvShowID)
    }

    /// Publishes the images that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Images](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-images)
    ///
    /// - Parameter seasonNumber: The season number of a TV show.
    /// - Parameter tvShowID: The ID of the TV show.
    public func imagesPublisher(forSeason seasonNumber: Int,
                                inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        tvShowSeasonService.fetchImages(forSeason: seasonNumber, inTVShow: tvShowID)
    }

    /// Publishes the videos that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Videos](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-videos)
    ///
    /// - Parameter seasonNumber: The season number of a TV show.
    /// - Parameter tvShowID: The ID of the TV show.
    public func videosPublisher(forSeason seasonNumber: Int,
                                inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        tvShowSeasonService.fetchVideos(forSeason: seasonNumber, inTVShow: tvShowID)
    }

}
