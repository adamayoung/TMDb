//
//  TVShowSeasonVideoService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowSeasonVideoService {

    func fetch(forTVShow tvShowID: Int, seasonNumber: Int) -> AnyPublisher<VideoCollection, TMDbError>

}
