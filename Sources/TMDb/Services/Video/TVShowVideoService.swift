//
//  TVShowVideoService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowVideoService {

    func fetch(forTVShow tvShowID: Int) -> AnyPublisher<VideoCollection, TMDbError>

}
