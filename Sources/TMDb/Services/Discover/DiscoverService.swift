import Combine
import Foundation

public protocol DiscoverService {

    func fetchMovies(sortBy: MovieSortBy?, withPeople: [Person.ID]?,
                     page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

}

extension DiscoverService {

    public func fetchMovies(sortBy: MovieSortBy? = nil, withPeople: [Person.ID]? = nil,
                            page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        fetchMovies(sortBy: sortBy, withPeople: withPeople, page: page)
    }

    public func fetchTVShows(sortBy: TVShowSortBy? = nil,
                             page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        fetchTVShows(sortBy: sortBy, page: page)
    }

}
