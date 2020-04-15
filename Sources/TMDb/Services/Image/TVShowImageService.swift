//
//  TVShowImageService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol TVShowImageService {

  func fetch(forTVShow tvShowID: Int) -> AnyPublisher<ImageCollection, TMDbError>

}
