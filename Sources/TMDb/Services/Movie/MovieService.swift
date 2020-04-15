//
//  MovieService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Foundation

public typealias MovieService = DiscoverMoviesService & TrendingMoviesService & MovieFetchService & MovieRecommendationsService & SimilarMoviesService & MovieSearchService
