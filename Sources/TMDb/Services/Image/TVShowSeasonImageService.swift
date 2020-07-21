//
//  TVShowSeaonImageService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowSeaonImageService {

    func fetch(forTVShow tvShowID: Int, seasonNumber: Int) -> AnyPublisher<ImageCollection, TMDbError>

}
