//
//  MovieCreditsService.swift
//  TMDbCredits
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol MovieCreditsService {

  func fetch(forMovie movieID: Int) -> AnyPublisher<Credits, Error>

}
