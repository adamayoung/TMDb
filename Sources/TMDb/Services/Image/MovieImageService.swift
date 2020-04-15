//
//  MovieImageService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieImageService {

  func fetch(forMovie movieID: Int) -> AnyPublisher<ImageCollection, TMDbError>

}
