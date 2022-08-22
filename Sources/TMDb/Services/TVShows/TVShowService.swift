import Foundation

/// A service to fetch information about TV shows.
public protocol TVShowService: TVShowDetailsService, TVShowCreditsService, TVShowReviewService, TVShowImageryService,
                               TVShowListsService { }
