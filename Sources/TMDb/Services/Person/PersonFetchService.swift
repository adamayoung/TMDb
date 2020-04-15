//
//  PersonFetchService.swift
//  TMDb
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol PersonFetchService {

  func fetch(id: Int) -> AnyPublisher<Person, TMDbError>

}
