import Foundation

/// A service to search for movies, TV shows and people.
public typealias SearchService = MovieSearchService & TVShowSearchService & PersonSearchService & MediaSearchService
