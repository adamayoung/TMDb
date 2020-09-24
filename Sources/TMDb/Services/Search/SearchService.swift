import Combine
import Foundation

protocol SearchService {

    func searchAll(query: String, page: Int?) -> AnyPublisher<MediaPageableListDTO, TMDbError>

    func searchMovies(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    func searchTVShows(query: String, firstAirDateYear: Int?,
                       page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

    func searchPeople(query: String, page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError>

}
