import Combine
import Foundation

protocol TrendingService {

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType,
                      page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}
