import Foundation

/// A service to discover movies and TV shows by different types of data like average rating, number of votes, genres and certifications.
public typealias DiscoverService = MovieDiscoverService & TVShowDiscoverService
