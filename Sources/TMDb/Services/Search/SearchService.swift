import Combine
import Foundation

public protocol SearchService {

    func searchAll(query: String, page: Int?) -> AnyPublisher<MultiTypePageableListResult, TMDbError>

    func searchMovies(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableListResult, TMDbError>

    func searchTVShows(query: String, firstAirDateYear: Int?,
                       page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError>

    func searchPeople(query: String, page: Int?) -> AnyPublisher<PersonPageableListResult, TMDbError>

}

extension SearchService {

    public func searchAll(query: String, page: Int? = nil) -> AnyPublisher<MultiTypePageableListResult, TMDbError> {
        searchAll(query: query, page: page)
    }

    public func searchMovies(query: String, year: Int? = nil,
                             page: Int? = nil) -> AnyPublisher<MoviePageableListResult, TMDbError> {
        searchMovies(query: query, year: year, page: page)
    }

    public func searchTVShows(query: String, firstAirDateYear: Int? = nil,
                              page: Int? = nil) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    public func searchPeople(query: String, page: Int? = nil) -> AnyPublisher<PersonPageableListResult, TMDbError> {
        searchPeople(query: query, page: page)
    }

}
