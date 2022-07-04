import Foundation

/// A service to fetch information about movies.
public typealias MovieService = MovieDetailsService & MovieCreditsService & MovieReviewService & MovieImageryService
& MovieListsService
