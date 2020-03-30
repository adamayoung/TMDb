//
//  ConfigurationService.swift
//  TMDbConfiguration
//
//  Created by Adam Young on 16/03/2020.
//

import Combine
import Foundation

public protocol ConfigurationService {

  func fetch() -> AnyPublisher<Configuration, Error>

}
