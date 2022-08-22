import Foundation

/// A service to search for movies, TV shows and people.
public protocol SearchService: MovieSearchService, TVShowSearchService, PersonSearchService, MediaSearchService { }
