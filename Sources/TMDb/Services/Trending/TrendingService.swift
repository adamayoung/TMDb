import Foundation

/// A service to fetch the daily or weekly trending movies, TV shows or people.
public protocol TrendingService: MovieTrendingService, TVShowTrendingService, PersonTrendingService { }
