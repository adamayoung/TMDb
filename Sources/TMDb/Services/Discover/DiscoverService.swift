import Combine
import Foundation

public protocol DiscoverService {

    func fetchMovies(sortBy: MovieSortBy?, withPeople: [Person.ID]?,
                     page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

}
