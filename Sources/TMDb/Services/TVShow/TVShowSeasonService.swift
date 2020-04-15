//
//  TVShowSeasonService.swift
//  TMDb
//
//  Created by Adam Young on 15/04/2020.
//

import Combine
import Foundation

public protocol TVShowSeasonService {

  func fetchSeason(_ seasonNumber: Int, forTVShow tvShowID: Int) -> AnyPublisher<TVShowSeason, TMDbError>

}
