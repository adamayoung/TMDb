import Combine
import Foundation

public protocol MovieTVShowAPI {

    /// Sets the TMDb API Key to be used with requests to the TMDb API.
    ///
    /// - Note: [TMDb API - Getting Started: Authentication](https://developers.themoviedb.org/3/getting-started/authentication#api-key)
    ///
    /// - Parameter apiKey: The TMDb API Key.
    static func setAPIKey(_ apiKey: String)

    /// Publishes the officially supported movie certifications on TMDb.
    ///
    /// - Note: [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    func movieCertificationsPublisher() -> AnyPublisher<[String: [CertificationDTO]], TMDbError>

    /// Publishes the officially supported TV show certifications on TMDb.
    ///
    /// - Note: [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    func tvShowCertificationsPublisher() -> AnyPublisher<[String: [CertificationDTO]], TMDbError>

    /// Publishes the TMDb API system wide configuration information.
    ///
    /// - Note: [TMDb API - Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    func apiConfigurationPublisher() -> AnyPublisher<APIConfigurationDTO, TMDbError>

    /// Publishes movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Parameter sortBy: How results should be sorted.
    /// - Parameter withPeople: A list of Person IDs which to return only movies they have appeared in.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func discoverMoviesPublisher(sortBy: MovieSortBy?, withPeople: [PersonDTO.ID]?,
                                 page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    /// Publishes TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Parameter sortBy: How results should be sorted.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func discoverTVShowsPublisher(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    /// Publishes the primary information about a movie.
    ///
    /// - Note: [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameter id: The ID of the movie.
    func detailsPublisher(forMovie id: MovieDTO.ID) -> AnyPublisher<MovieDTO, TMDbError>

    /// Publishes the cast and crew of a movie.
    ///
    /// - Note: [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameter movieID: The ID of the movie.
    func creditsPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ShowCreditsDTO, TMDbError>

    /// Publishes the user reviews for a movie.
    ///
    /// - Note: [TMDb API - Movie: Reviews](https://developers.themoviedb.org/3/movies/get-movie-reviews)
    ///
    /// - Parameter movieID: The ID of the movie.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func reviewsPublisher(forMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError>

    /// Publishes the images that belong to a movie.
    ///
    /// - Note: [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameter movieID: The ID of the movie.
    func imagesPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError>

    /// Publishes the videos that have been added to a movie.
    ///
    /// - Note: [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameter movieID: The ID of the movie.
    func videosPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError>

    /// Publishes a list of recommended movies for a movie.
    ///
    /// - Note: [TMDb API - Movie: Recommendations](https://developers.themoviedb.org/3/movies/get-movie-recommendations)
    ///
    /// - Parameter movieID: The ID of the movie for get recommendations for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func recommendationsPublisher(forMovie movieID: MovieDTO.ID,
                                  page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    /// Publishes a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// - Note: [TMDb API - Movie: Similar](https://developers.themoviedb.org/3/movies/get-similar-movies)
    ///
    /// - Parameter movieID: The ID of the movie for get similar movies for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func moviesPublisher(similarToMovie movieID: MovieDTO.ID,
                         page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    /// Publishes a list current popular movies.
    ///
    /// - Note: [TMDb API - Movie: Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
    ///
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func popularMoviesPublisher(page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    /// Publishes the primary information about a person.
    ///
    /// - Note: [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameter id: The ID of the person.
    func detailsPublisher(forPerson id: PersonDTO.ID) -> AnyPublisher<PersonDTO, TMDbError>

    /// Publishes the combine movie and TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameter id: The ID of the person.
    func combinedCreditsPublisher(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonCombinedCreditsDTO, TMDbError>

    /// Publishes the movie credits of a person.
    ///
    /// - Note: [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameter id: The ID of the person.
    func movieCreditsPublisher(
        forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonMovieCreditsDTO, TMDbError>

    /// Publishes the TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameter id: The ID of the person.
    func tvShowCredits(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonTVShowCreditsDTO, TMDbError>

    /// Publishes the images for a person.
    ///
    /// - Note: [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameter id: The ID of the person.
    func imagesPublisher(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonImageCollectionDTO, TMDbError>

    /// Publishes the list of known for shows for a person.
    ///
    /// - Parameter id: The ID of the person.
    func knownForPublisher(forPerson personID: PersonDTO.ID) -> AnyPublisher<[ShowDTO], TMDbError>

    /// Publishes the list of popular people.
    ///
    /// - Note: [TMDb API - People: Popular](https://developers.themoviedb.org/3/people/get-popular-people)
    ///
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func popularPeoplePublisher(page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError>

    /// Publishes search results for movies, TV shows and people based on a query..
    ///
    /// - Note: [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func searchPublisher(withQuery query: String, page: Int?) -> AnyPublisher<MediaPageableListDTO, TMDbError>

    /// Publishes search results for movies.
    ///
    /// - Note: [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter year: The year to filter results for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    func searchMoviesPublisher(withQuery query: String, year: Int?,
                               page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    /// Publishes search results for TV shows.
    ///
    /// - Note: [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter firstAirDateYear: The year of first air date to filter results for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    func searchTVShowsPublisher(withQuery query: String, firstAirDateYear: Int?,
                                page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    /// Publishes search results for people.
    ///
    /// - Note: [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Parameter query: A text query to search for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    func searchPeoplePublisher(withQuery query: String, page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError>

    /// Publishes a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Parameter timeWindow: Daily or weekly time window.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    func trendingMoviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                                 page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    /// Publishes a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Parameter timeWindow: Daily or weekly time window.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    func trendingTVShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                                  page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    /// Publishes a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Parameter timeWindow: Daily or weekly time window.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000) (Minimum: 1, Maximum: 1000)
    func trendingPeoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                                 page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError>

    /// Publishes the primary information about a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameter id: The ID of the TV show.
    func detailsPublisher(forTVShow id: TVShowDTO.ID) -> AnyPublisher<TVShowDTO, TMDbError>

    /// Publishes the cast and crew of a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    func creditsPublisher(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ShowCreditsDTO, TMDbError>

    /// Publishes the user reviews for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func reviewsPublisher(forTVShow tvShowID: TVShowDTO.ID,
                          page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError>

    /// Publishes the images that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    func imagesPublisher(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError>

    /// Publishes the videos that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    func videosPublisher(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError>

    /// Publishes a list of recommended TV shows for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Parameter tvShowID: The ID of the TV show.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func recommendationsPublisher(forTVShow tvShowID: TVShowDTO.ID,
                                  page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    /// Publishes a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// - Note: [TMDb API - TV: Similar](https://developers.themoviedb.org/3/tv/get-tv-movies)
    ///
    /// - Parameter tvShowID: The ID of the TV show for get similar TV shows for.
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func tvShowsPublisher(similarToTVShow tvShowID: TVShowDTO.ID,
                          page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    /// Publishes a list current popular TV shows.
    ///
    /// - Note: [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Parameter page: The page of results to return. (Minimum: 1, Maximum: 1000)
    func popularTVShowsPublisher(page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    /// Publishes the primary information about a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Details](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-details)
    ///
    /// - Parameter seasonNumber: The season number of a TV show.
    /// - Parameter tvShowID: The ID of the TV show.
    func detailsPublisher(forSeason seasonNumber: Int,
                          inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<TVShowSeasonDTO, TMDbError>

    /// Publishes the images that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Images](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-images)
    ///
    /// - Parameter seasonNumber: The season number of a TV show.
    /// - Parameter tvShowID: The ID of the TV show.
    func imagesPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError>

    /// Publishes the videos that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Videos](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-videos)
    ///
    /// - Parameter seasonNumber: The season number of a TV show.
    /// - Parameter tvShowID: The ID of the TV show.
    func videosPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError>

}

public extension MovieTVShowAPI {

    func discoverMoviesPublisher(sortBy: MovieSortBy? = .default, withPeople: [PersonDTO.ID]? = nil,
                                 page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        discoverMoviesPublisher(sortBy: sortBy, withPeople: withPeople, page: page)
    }

    func discoverTVShowsPublisher(sortBy: TVShowSortBy? = nil,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        discoverTVShowsPublisher(sortBy: sortBy, page: page)

    }

    func reviewsPublisher(forMovie movieID: MovieDTO.ID,
                          page: Int? = nil) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
        reviewsPublisher(forMovie: movieID, page: page)
    }

    func recommendationsPublisher(forMovie movieID: MovieDTO.ID,
                                  page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        recommendationsPublisher(forMovie: movieID, page: page)
    }

    func moviesPublisher(similarToMovie movieID: MovieDTO.ID,
                         page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        moviesPublisher(similarToMovie: movieID, page: page)
    }

    func popularMoviesPublisher(page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        popularMoviesPublisher(page: page)
    }

    func popularPeoplePublisher(page: Int? = nil) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        popularPeoplePublisher(page: page)
    }

    func searchPublisher(withQuery query: String, page: Int? = nil) -> AnyPublisher<MediaPageableListDTO, TMDbError> {
        searchPublisher(withQuery: query, page: page)
    }

    func searchMoviesPublisher(withQuery query: String, year: Int?,
                               page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        searchMoviesPublisher(withQuery: query, year: year, page: page)
    }

    func searchTVShowsPublisher(withQuery query: String, firstAirDateYear: Int?,
                                page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        searchTVShowsPublisher(withQuery: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    func searchPeoplePublisher(withQuery query: String,
                               page: Int? = nil) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        searchPeoplePublisher(withQuery: query, page: page)
    }

    func trendingMoviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                 page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        trendingMoviesPublisher(inTimeWindow: timeWindow, page: page)
    }

    func trendingTVShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        trendingTVShowsPublisher(inTimeWindow: timeWindow, page: page)
    }

    func trendingPeoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                 page: Int? = nil) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        trendingPeoplePublisher(inTimeWindow: timeWindow, page: page)
    }

    func reviewsPublisher(forTVShow tvShowID: TVShowDTO.ID,
                          page: Int? = nil) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
        reviewsPublisher(forTVShow: tvShowID, page: page)
    }

    func recommendationsPublisher(forTVShow tvShowID: TVShowDTO.ID,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        recommendationsPublisher(forTVShow: tvShowID, page: page)
    }

    func tvShowsPublisher(similarToTVShow tvShowID: TVShowDTO.ID,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        tvShowsPublisher(similarToTVShow: tvShowID, page: page)
    }

    func popularTVShowsPublisher(page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        popularTVShowsPublisher(page: page)
    }

}
