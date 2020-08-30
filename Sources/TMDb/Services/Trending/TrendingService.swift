import Combine
import Foundation

public protocol TrendingService {

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType,
                      page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType,
                     page: Int?) -> AnyPublisher<PersonPageableListResult, TMDbError>

}

extension TrendingService {

    public func fetchMovies(timeWindow: TrendingTimeWindowFilterType = .default,
                            page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
        fetchMovies(timeWindow: timeWindow, page: page)
    }

    public func fetchTVShows(timeWindow: TrendingTimeWindowFilterType = .default,
                             page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        fetchTVShows(timeWindow: timeWindow, page: page)
    }

    public func fetchPeople(timeWindow: TrendingTimeWindowFilterType = .default,
                            page: Int? = nil) -> AnyPublisher<PersonPageableListResult, TMDbError> {
        fetchPeople(timeWindow: timeWindow, page: page)
    }

}
