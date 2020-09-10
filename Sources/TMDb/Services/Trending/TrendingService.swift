import Combine
import Foundation

public protocol TrendingService {

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType,
                      page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}

extension TrendingService {

    public func fetchMovies(timeWindow: TrendingTimeWindowFilterType = .default,
                            page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        fetchMovies(timeWindow: timeWindow, page: page)
    }

    public func fetchTVShows(timeWindow: TrendingTimeWindowFilterType = .default,
                             page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        fetchTVShows(timeWindow: timeWindow, page: page)
    }

    public func fetchPeople(timeWindow: TrendingTimeWindowFilterType = .default,
                            page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        fetchPeople(timeWindow: timeWindow, page: page)
    }

}
