import Combine
import Foundation

protocol SearchService {

    func searchAll(query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError>

    func searchMovies(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func searchTVShows(query: String, firstAirDateYear: Int?,
                       page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    func searchPeople(query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}
