//
//  TVShowCreditsService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowCreditsService {

  func fetch(forTVShow tvShowID: Int) -> AnyPublisher<Credits, TMDbError>

}
