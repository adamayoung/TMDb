import Foundation

/// A service to fetch information about TV shows.
public typealias TVShowService = TVShowDetailsService & TVShowCreditsService & TVShowReviewService
& TVShowImageryService & TVShowListsService
