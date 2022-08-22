import Foundation

/// A service to fetch information about movies.
public protocol MovieService: MovieDetailsService, MovieCreditsService, MovieReviewService, MovieImageryService,
                              MovieListsService { }
