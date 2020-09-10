import Combine
import Foundation

public protocol SearchService {

    func searchAll(query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError>

    func searchMovies(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    func searchTVShows(query: String, firstAirDateYear: Int?,
                       page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    func searchPeople(query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}

extension SearchService {

    public func searchAll(query: String, page: Int? = nil) -> AnyPublisher<MediaPageableList, TMDbError> {
        searchAll(query: query, page: page)
    }

    public func searchMovies(query: String, year: Int? = nil,
                             page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        searchMovies(query: query, year: year, page: page)
    }

    public func searchTVShows(query: String, firstAirDateYear: Int? = nil,
                              page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    public func searchPeople(query: String, page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        searchPeople(query: query, page: page)
    }

}
