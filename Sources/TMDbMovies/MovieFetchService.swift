//
//  MovieFetchService.swift
//  TMDbMovies
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieFetchService {

  func fetch(id: Int) -> AnyPublisher<Movie, Error>

}
