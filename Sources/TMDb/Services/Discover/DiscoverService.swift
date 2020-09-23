import Combine
import Foundation

public protocol DiscoverService {

    func fetchMovies(sortBy: MovieSortBy?, withPeople: [PersonDTO.ID]?,
                     page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

}
