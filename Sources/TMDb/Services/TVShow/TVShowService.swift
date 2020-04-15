//
//  TVShowService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public typealias TVShowService = DiscoverTVShowsService & TrendingTVShowsService & TVShowFetchService & TVShowRecommendationsService & SimilarTVShowsService & TVShowSearchService & TVShowSeasonService
